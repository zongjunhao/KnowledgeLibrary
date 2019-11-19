package com.syzc.common.service;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.FileUtils;

import com.alibaba.fastjson.JSON;
import com.jfinal.kit.PathKit;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.IAtom;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.upload.UploadFile;
import com.syzc.common.kit.BaseResponse;
import com.syzc.common.kit.DownloadInfo;
import com.syzc.common.kit.ElasticSearch;
import com.syzc.common.kit.FileContent;
import com.syzc.common.kit.KnowledgeDetails;
import com.syzc.common.kit.KnowledgeWithText;
import com.syzc.common.kit.OfficeDoc2PDF;
import com.syzc.common.kit.ResultCodeEnum;
import com.syzc.common.kit.SendMail;
import com.syzc.common.model.Collection;
import com.syzc.common.model.CollectionAState;
import com.syzc.common.model.Comment;
import com.syzc.common.model.Firm;
import com.syzc.common.model.Knowledge;
import com.syzc.common.model.Label;
import com.syzc.common.model.Path;
import com.syzc.common.model.Type;
import com.syzc.common.model.User;

public class UserService {
	public static ElasticSearch esClient = new ElasticSearch();

	/**
	 * 用户登录
	 * 
	 * @param u_mail
	 * @param u_pwd
	 * @return
	 */
	public BaseResponse login(String u_mail, String u_pwd) {

		BaseResponse baseResponse = new BaseResponse();
		boolean exist = false;
		boolean correct = false;
		User accountInfo = null;
		int firmId = 1;
		Firm firm = null;
		int firmAuditState = 1;

		// 找出所有用户的邮箱
		List<User> usermails = User.dao.find("SELECT u_email FROM user");
		System.out.println(usermails);
		// 设置当前用户
		User thisUser = new User().set("u_email", u_mail);
		// 判断用户是否存在
		exist = usermails.contains(thisUser);

		// 如果用户存在，首先判断公司审核是否通过，接着判断用户密码是否正确
		if (exist) {
			accountInfo = User.dao.findFirst("SELECT * FROM user WHERE u_email = ?", u_mail);
			
			// 获取用户所属公司的ID
			firmId = accountInfo.getUFirm();
			// 查找该公司
			firm = Firm.dao.findById(firmId);
			if (firm != null) {
				// 获取公司的审核状态
				firmAuditState = firm.getFState();
				if(firmAuditState == 1) {// 未进行审核
					baseResponse.setResult(ResultCodeEnum.LOGIN_FAILURE_NO_AUDIT);
				} else if (firmAuditState == 3) {// 审核不通过
					baseResponse.setResult(ResultCodeEnum.LOGIN_FAILURE_AUDIT_NOT_PASS);
				} else if (firmAuditState == 2) {// 审核通过
					// 判断密码是否正确
					correct = accountInfo.get("u_pwd").equals(u_pwd);
					if (correct) { // 用户存在且密码正确，返回用户所有信息
						baseResponse.setResult(ResultCodeEnum.LOGIN_SUCCESS);
						baseResponse.setData(accountInfo);
					} else { // 密码不正确，登陆失败
						baseResponse.setResult(ResultCodeEnum.LOGIN_ERROR);
					}
				}
			}
		} else { // 用户不存在，登陆失败
			baseResponse.setResult(ResultCodeEnum.NO_EXIST_USER);
		}

		return baseResponse;
	}

	/**
	 * 查看用户详细信息
	 * 
	 * @param u_id
	 * @return
	 */
	public BaseResponse viewUserInfo(String u_id) {

		BaseResponse baseResponse = new BaseResponse();
		User accountInfo = null;

		accountInfo = User.dao.findFirst("SELECT * FROM user WHERE u_id = ?", u_id);

		if (accountInfo != null) {
			baseResponse.setData(accountInfo);
			baseResponse.setResult(ResultCodeEnum.DB_FIND_SUCCESS);
		} else {
			baseResponse.setResult(ResultCodeEnum.DB_FIND_FAILURE);
		}

		return baseResponse;
	}

	/**
	 * 修改用户信息
	 * 
	 * @param u_id
	 * @param u_name
	 * @param u_pwd
	 * @param u_gender
	 * @param u_phone
	 * @param u_age
	 * @param u_mail
	 * @return
	 */
	public BaseResponse modifyUserInfo(String u_id, String u_name, String u_pwd, String u_gender, String u_phone,
			String u_age, String u_mail) {
		BaseResponse baseResponse = new BaseResponse();

		// 找出所有用户的邮箱
		List<User> usermails = User.dao.find("SELECT u_email FROM user");
		System.out.println(usermails);
		// 设置当前邮箱
		User thisMail = new User().set("u_email", u_mail);
		// 判断邮箱是否存在
		boolean exist = usermails.contains(thisMail);
		// 找出需要修改的用户
		User userToChange = User.dao.findById(u_id);

		// 邮箱已经存在，且不是用户原有的邮箱（该邮箱被其他用户占用），修改失败
		if (exist && !u_mail.equals(userToChange.getUEmail())) {
			baseResponse.setResult(ResultCodeEnum.UPDATE_FAILURE_MAIL_EXISTED);
		} else if (userToChange != null) { // 用户不为空
			userToChange.setUName(u_name);
			if(!(u_pwd == "" || u_pwd == null)) {
				userToChange.setUPwd(u_pwd);
			}
			userToChange.setUGender(u_gender);
			userToChange.setUPhone(u_phone);
			userToChange.setUEmail(u_mail);
			userToChange.setUAge(Integer.parseInt(u_age));
			if (userToChange.update()) { // 修改成功
				baseResponse.setResult(ResultCodeEnum.INFO_UPDATE_SUCESS);
			} else {
				baseResponse.setResult(ResultCodeEnum.INFO_UPDATE_FAILURE);
			}
		} else {
			baseResponse.setResult(ResultCodeEnum.INFO_UPDATE_FAILURE);
		}

		return baseResponse;
	}

	/**
	 * 查看所有标签信息
	 * 
	 * @param f_id
	 * @return
	 */
	public BaseResponse viewLabels(String f_id) {

		BaseResponse baseResponse = new BaseResponse();
		List<Label> labels = Label.dao.find("SELECT * FROM label WHERE l_f_id = ?", f_id);

		if (labels.isEmpty()) {
			baseResponse.setResult(ResultCodeEnum.DB_FIND_FAILURE);
		} else {
			baseResponse.setData(labels);
			baseResponse.setResult(ResultCodeEnum.DB_FIND_SUCCESS);
		}

		return baseResponse;
	}

	/**
	 * 返回某一类别的审核已通过的所有知识（排序方式默认）
	 * 
	 * @param f_id
	 * @param l_id
	 * @return
	 */
	public BaseResponse viewAllKnowledge(String f_id, String l_id, String uIdString) {

		BaseResponse baseResponse = new BaseResponse();

		List<CollectionAState> collectionAStates = new ArrayList<CollectionAState>();
		// 查找该公司内的所有知识
		String sqlStr = "SELECT * FROM knowledge " + " WHERE k_f_id =" + f_id + " AND k_state = 2 "
				+ " AND k_id IN( SELECT t_k_id FROM type WHERE t_l_id =" + l_id + ")";

		List<Knowledge> knowledges = Knowledge.dao.find(sqlStr);

		// 查找该用户收藏的所有知识
		List<Knowledge> knowledges2 = new ArrayList<Knowledge>();

		List<Collection> collections = Collection.dao
				.find("select c_k_id from collection where c_u_id =" + "'" + uIdString + "'");
		for (Collection collection : collections) {
			Knowledge knowledge = Knowledge.dao.findById(collection.getCKId());
			knowledges2.add(knowledge);
		}
		for (Knowledge knowledge : knowledges) {
			CollectionAState collectionAState = new CollectionAState();
			if (knowledges2.contains(knowledge)) {
				// 用户收藏了该知识
				collectionAState.setIsCollect(1);
				collectionAState.setKnowledge(knowledge);
			} else {
				// 用户未收藏该知识
				collectionAState.setIsCollect(0);
				collectionAState.setKnowledge(knowledge);
			}
			collectionAStates.add(collectionAState);
		}

		if (collectionAStates.isEmpty()) {
			baseResponse.setResult(ResultCodeEnum.DB_FIND_FAILURE);
		} else {

			baseResponse.setData(collectionAStates);
			baseResponse.setResult(ResultCodeEnum.DB_FIND_SUCCESS);
		}

		return baseResponse;
	}

//	/**
//	 * 查看某一特定知识的详细信息
//	 * 
//	 * @param k_id
//	 * @return
//	 */
//	public BaseResponse viewSpecificKnowledge(String k_id) {
//		BaseResponse baseResponse = new BaseResponse();
//
//		Knowledge knowledge = Knowledge.dao.findById(k_id);// 知识表中查询此条知识
//		System.out.println("knowledge:::" + knowledge);
//		if (knowledge != null) { // 查询结果不为空
//
//			// 点击量+1
//			knowledge.setKClick(knowledge.getKClick() + 1);
//			knowledge.update();
//
//			// 查找本条知识对应的评论
//			String commentSql = "SELECT `user`.u_name, `comment`.com_desc FROM "
//					+ "`user` INNER JOIN `comment` ON `user`.u_id = `comment`.com_u_id "
//					+ " WHERE `comment`.com_k_id = " + k_id;
//			List<Record> comments = Db.find(commentSql);
//			System.out.println("comments:::" + comments);
//
//			// 查询本条知识的所属类别
//			String labelSql = "SELECT label.l_name FROM " + " type INNER JOIN label ON type.t_l_id = label.l_id  "
//					+ " WHERE type.t_k_id = " + k_id;
//			List<Label> labels = Label.dao.find(labelSql);
//			System.out.println("labels:::" + labels);
//
//			System.out.println(JsonKit.toJson(knowledge));
//			System.out.println(JsonKit.toJson(comments));
//			System.out.println(JsonKit.toJson(labels));
//
//			// 将三条信息组合成为符合JSON格式的字符串
//			String dataStr = "{\"knowledge\":" + JsonKit.toJson(knowledge) + ",\"comment\":" + JsonKit.toJson(comments)
//					+ ",\"labels\":" + JsonKit.toJson(labels) + "}";
//			System.out.println(dataStr);
//
//			// 将字符串转换为JSON
//			JSONObject dataJson = JSONObject.parseObject(dataStr);
//			System.out.println(dataJson);
//
//			// 设置响应信息
//			baseResponse.setData(dataJson);
//			baseResponse.setResult(ResultCodeEnum.DB_FIND_SUCCESS);
//			System.out.println(baseResponse);
//		} else {
//			baseResponse.setResult(ResultCodeEnum.DB_FIND_FAILURE);
//		}
//		return baseResponse;
//	}

	/**
	 * 查看某一特定知识的详细信息
	 * 
	 * @param k_id
	 * @param u_id
	 * @return
	 */
	public BaseResponse viewSpecificKnowledge(String k_id, String u_id) {

		BaseResponse baseResponse = new BaseResponse();
		KnowledgeDetails knowledgeDetails = new KnowledgeDetails();

		Knowledge knowledge = Knowledge.dao.findById(k_id);// 知识表中查询此条知识
		System.out.println("knowledge:::" + knowledge);
		if (knowledge != null) { // 查询结果不为空

			// 点击量+1
			knowledge.setKClick(knowledge.getKClick() + 1);
			knowledge.update();

			// 查找本条知识对应的评论
			String commentSql = "SELECT `user`.u_name, `comment`.com_desc FROM "
					+ "`user` INNER JOIN `comment` ON `user`.u_id = `comment`.com_u_id "
					+ " WHERE `comment`.com_k_id = " + k_id;
			List<Record> comments = Db.find(commentSql);
			System.out.println("comments:::" + comments);

			// 查询本条知识的所属类别
			String labelSql = "SELECT label.l_name FROM " + " type INNER JOIN label ON type.t_l_id = label.l_id  "
					+ " WHERE type.t_k_id = " + k_id;
			List<Label> labels = Label.dao.find(labelSql);
			System.out.println("labels:::" + labels);

			// 查找本条知识作者姓名
			// 判断用户是否为空（是否被删除）
			String authorName = null;
			int flag = knowledge.toString().indexOf("k_u_id:null");
			if (flag == -1) {
				User user = User.dao.findById(knowledge.getKUId());
				authorName = user.getUName();
			} else {
				authorName = "佚名";
			}

			// 将信息放入KnowledgeDetails中
			knowledgeDetails.setKnowledge(knowledge);
			knowledgeDetails.setComment(comments);
			knowledgeDetails.setLabels(labels);
			knowledgeDetails.setAuthorName(authorName);

			// 查找该用户收藏的所有知识
			List<Collection> collections = Collection.dao
					.find("select c_k_id from collection where c_u_id = " + "'" + u_id + "'");
			// 设置当前知识
			Collection collection = new Collection();
			collection.setCKId(Integer.parseInt(k_id));
			// 如果收藏的知识包含当前知识，isCollect为 1
			if (collections.contains(collection)) {
				knowledgeDetails.setIsCollect(1);
			} else {
				knowledgeDetails.setIsCollect(0);
			}

			// 设置响应信息
			baseResponse.setData(knowledgeDetails);
			baseResponse.setResult(ResultCodeEnum.DB_FIND_SUCCESS);
			System.out.println(baseResponse);
		} else {
			baseResponse.setResult(ResultCodeEnum.DB_FIND_FAILURE);
		}
		return baseResponse;
	}

	/**
	 * 搜索知识，返回以某种方式排序的符合条件（不按类别，全部）的所有知识
	 * 
	 * @param search_msg
	 * @param f_id
	 * @param orderc
	 * @return
	 */
	public BaseResponse searchKnowledges(String search_msg, String f_id, String order, String uIdString) {

		BaseResponse baseResponse = new BaseResponse();
		List<KnowledgeWithText> knowledgeWithTexts = new ArrayList<KnowledgeWithText>();
		// 查找该用户收藏的所有知识
		List<Knowledge> CollectedKnowledges = new ArrayList<Knowledge>();
		List<Collection> collections = Collection.dao
				.find("select c_k_id from collection where c_u_id = " + "'" + uIdString + "'");
		for (Collection collection : collections) {
			Knowledge knowledge = Knowledge.dao.findById(collection.getCKId());
			CollectedKnowledges.add(knowledge);
		}
		
		if(search_msg == "" || search_msg == null) {
			// 查找按一定条件排序的该公司审核已经通过的特定知识（模糊查询）
			String sqlStr = "SELECT * FROM knowledge " + " WHERE k_f_id = " + f_id + " AND k_state = 2"
					+ " AND k_name LIKE '%" + search_msg + "%' " + " ORDER BY " + order + " DESC";
			List<Knowledge> knowledges = Knowledge.dao.find(sqlStr);
			// 将用户收藏的知识设置状态位 isCollect 为 0
			for (Knowledge knowledge : knowledges) {
				KnowledgeWithText knowledgeWithText = new KnowledgeWithText();
				if (CollectedKnowledges.contains(knowledge)) {
					// 用户收藏了该信息
					knowledgeWithText.setIsCollect(1);
				} else {
					// 用户未收藏该信息
					knowledgeWithText.setIsCollect(0);
				}
				knowledgeWithText.setKnowledge(knowledge);
				knowledgeWithText.setK_name(knowledge.getKName());
				knowledgeWithTexts.add(knowledgeWithText);
			}
			if (knowledgeWithTexts.isEmpty()) {
				baseResponse.setResult(ResultCodeEnum.DB_FIND_FAILURE);
			} else {
				baseResponse.setData(knowledgeWithTexts);
				baseResponse.setResult(ResultCodeEnum.DB_FIND_SUCCESS);
			}
			return baseResponse;
		}

		// 获取es查询结果
		List<Map<String, Object>> knowledges = esClient.search(f_id, search_msg);
		System.out.println(knowledges);
		for (Map<String, Object> knowledge : knowledges) {
			KnowledgeWithText knowledgeWithText = new KnowledgeWithText();
			//从Map中取出搜索结果
			String k_id = String.valueOf(knowledge.get("k_id"));
			String k_name = String.valueOf(knowledge.get("k_name"));
			String k_text = String.valueOf(knowledge.get("k_text"));
			Knowledge knowledge2 = Knowledge.dao.findById(k_id);
			knowledgeWithText.setK_name(k_name);
			knowledgeWithText.setK_text(k_text);
			knowledgeWithText.setKnowledge(knowledge2);
			if(CollectedKnowledges.contains(knowledge2)) {
				knowledgeWithText.setIsCollect(1);
			}else {
				knowledgeWithText.setIsCollect(0);
			}
			knowledgeWithTexts.add(knowledgeWithText);
		}

		if (knowledgeWithTexts.isEmpty()) {
			baseResponse.setResult(ResultCodeEnum.DB_FIND_FAILURE);
		} else {
			baseResponse.setData(knowledgeWithTexts);
			baseResponse.setResult(ResultCodeEnum.DB_FIND_SUCCESS);
		}
		
		return baseResponse;
	}

//	/**
//	 * 搜索知识，返回以某种方式排序的符合条件（不按类别，全部）的所有知识
//	 * 
//	 * @param search_msg
//	 * @param f_id
//	 * @param orderc
//	 * @return
//	 */
//	public BaseResponse searchKnowledges(String search_msg, String f_id, String order, String uIdString) {
//
//		BaseResponse baseResponse = new BaseResponse();
//		List<CollectionAState> collectionAStates = new ArrayList<CollectionAState>();
//
//		// 查找按一定条件排序的该公司审核已经通过的特定知识（模糊查询）
//		String sqlStr = "SELECT * FROM knowledge " + " WHERE k_f_id = " + f_id + " AND k_state = 2"
//				+ " AND k_name LIKE '%" + search_msg + "%' " + " ORDER BY " + order + " DESC";
//		List<Knowledge> knowledges = Knowledge.dao.find(sqlStr);
//
//		// 查找该用户收藏的所有知识
//		List<Knowledge> knowledges2 = new ArrayList<Knowledge>();
//
//		List<Collection> collections = Collection.dao
//				.find("select c_k_id from collection where c_u_id = " + "'" + uIdString + "'");
//		for (Collection collection : collections) {
//			Knowledge knowledge = Knowledge.dao.findById(collection.getCKId());
//			knowledges2.add(knowledge);
//		}
//
//		// 将用户收藏的知识设置状态位 isCollect 为 0
//		for (Knowledge knowledge : knowledges) {
//			CollectionAState collectionAState = new CollectionAState();
//			if (knowledges2.contains(knowledge)) {
//				// 用户收藏了该信息
//				collectionAState.setIsCollect(1);
//				collectionAState.setKnowledge(knowledge);
//			} else {
//				// 用户未收藏该信息
//				collectionAState.setIsCollect(0);
//				collectionAState.setKnowledge(knowledge);
//			}
//			collectionAStates.add(collectionAState);
//		}
//
//		if (collectionAStates.isEmpty()) {
//			baseResponse.setResult(ResultCodeEnum.DB_FIND_FAILURE);
//		} else {
//			baseResponse.setData(collectionAStates);
//			baseResponse.setResult(ResultCodeEnum.DB_FIND_SUCCESS);
//		}
//
//		return baseResponse;
//	}

	/**
	 * 搜索知识，返回以某种方式排序的符合条件（按类别，全部）的所有知识
	 * 
	 * @param search_msg
	 * @param f_id
	 * @param order
	 * @param l_id
	 * @param uIdString
	 * @return
	 */
	public BaseResponse searchKnowledgesByLabel(String search_msg, String f_id, String order, String l_id,
			String uIdString) {

		BaseResponse baseResponse = new BaseResponse();
		List<CollectionAState> collectionAStates = new ArrayList<CollectionAState>();

		String sqlStr = "SELECT * FROM knowledge " + " WHERE k_f_id = " + f_id + " AND k_state = 2 "
				+ " AND k_name LIKE '%" + search_msg + "%' " + " AND k_id IN(SELECT t_k_id FROM type WHERE t_l_id = "
				+ l_id + " )" + " ORDER BY " + order + " DESC";
		List<Knowledge> knowledges = Knowledge.dao.find(sqlStr);

		// 查找该用户收藏的所有知识
		List<Knowledge> knowledges2 = new ArrayList<Knowledge>();

		List<Collection> collections = Collection.dao
				.find("select c_k_id from collection where c_u_id = " + "'" + uIdString + "'");
		for (Collection collection : collections) {
			Knowledge knowledge = Knowledge.dao.findById(collection.getCKId());
			knowledges2.add(knowledge);
		}

		// 将用户收藏的知识设置状态位 isCollect 为 1
		for (Knowledge knowledge : knowledges) {
			CollectionAState collectionAState = new CollectionAState();
			if (knowledges2.contains(knowledge)) {
				// 用户收藏了该信息
				collectionAState.setIsCollect(1);
				collectionAState.setKnowledge(knowledge);
			} else {
				// 用户未收藏该信息
				collectionAState.setIsCollect(0);
				collectionAState.setKnowledge(knowledge);
			}
			collectionAStates.add(collectionAState);
		}

		if (collectionAStates.isEmpty()) {
			baseResponse.setResult(ResultCodeEnum.DB_FIND_FAILURE);
		} else {
			baseResponse.setData(collectionAStates);
			baseResponse.setResult(ResultCodeEnum.DB_FIND_SUCCESS);
		}

		return baseResponse;
	}

	/**
	 * 用户收藏知识
	 * 
	 * @param u_id
	 * @param k_id
	 * @return
	 */
	public BaseResponse collect(String u_id, String k_id) {

		BaseResponse baseResponse = new BaseResponse();

		// 查找词条收藏记录在表中是否存在
		String sqlStr = "SELECT * FROM collection " + " WHERE c_u_id = " + u_id + " AND c_k_id = " + k_id;
		Collection collection = Collection.dao.findFirst(sqlStr);
		if (collection != null) {
			baseResponse.setResult(ResultCodeEnum.COLLECTION_EXISTED);
			return baseResponse;
		}

		// 使用事务，将此次收藏对应的记录加到收藏表中，并将知识的收藏量+1
		boolean succeed = Db.tx(new IAtom() {
			@Override
			public boolean run() throws SQLException {
				// TODO Auto-generated method stub

				// 保存用户收藏记录
				Collection collection = new Collection();
				collection.setCUId(Integer.parseInt(u_id));
				collection.setCKId(Integer.parseInt(k_id));

				// 收藏量+1
				Knowledge knowledge = Knowledge.dao.findById(Integer.parseInt(k_id));
				knowledge.setKCollect(knowledge.getKCollect() + 1);

				boolean result = collection.save() && knowledge.update();
				return result;
			}
		});

		if (succeed) { // 收藏成功
			baseResponse.setResult(ResultCodeEnum.COLLECTION_ADD_SUCCESS);
		} else {
			baseResponse.setResult(ResultCodeEnum.COLLECTION_ADD_FAILURE);
		}

		return baseResponse;
	}

	/**
	 * 删除用户收藏夹内的知识
	 * 
	 * @param u_id
	 * @param k_id
	 * @return
	 */
	public BaseResponse deleteCollections(String u_id, String[] k_id) {

		BaseResponse baseResponse = new BaseResponse();

		boolean succeed = Db.tx(new IAtom() {
			@Override
			public boolean run() throws SQLException {

				// TODO Auto-generated method stub
				Collection collection = new Collection();
				Knowledge knowledge = new Knowledge();

				for (String item : k_id) {

					// 将对应的收藏记录从收藏表中删除
					String sqlStr = "SELECT * FROM collection " + " WHERE c_u_id = " + u_id + " AND c_k_id = " + item;
					collection = Collection.dao.findFirst(sqlStr);

					if (collection != null) { // 查找成功
						if (!collection.delete()) {
							return false;
						}
					} else {
						return false;
					}

					// 将知识的收藏量-1
					knowledge = Knowledge.dao.findById(item);
					knowledge.setKCollect(knowledge.getKCollect() - 1);
					if (!knowledge.update()) {
						return false;
					}

				}

				return true;
			}
		});

		if (succeed) {
			baseResponse.setResult(ResultCodeEnum.DB_DELETE_SUCCESS);
		} else {
			baseResponse.setResult(ResultCodeEnum.DB_DELETE_FAILURE);
		}

		return baseResponse;
	}

	/**
	 * 显示用户收藏夹列表
	 * 
	 * @param u_id
	 * @return
	 */
	public BaseResponse displayCollections(String u_id) {

		BaseResponse baseResponse = new BaseResponse();
		String sqlStr = "SELECT * FROM knowledge " + " WHERE k_id IN(SELECT c_k_id FROM collection WHERE c_u_id = "
				+ u_id + ") " + " ORDER BY k_addtime DESC";
		List<Knowledge> knowledges = Knowledge.dao.find(sqlStr);

		if (knowledges.isEmpty()) {
			baseResponse.setResult(ResultCodeEnum.DB_FIND_FAILURE);
		} else {
			baseResponse.setData(knowledges);
			baseResponse.setResult(ResultCodeEnum.DB_FIND_SUCCESS);
		}

		return baseResponse;
	}

	/**
	 * 在用户收藏夹内搜索知识
	 * 
	 * @param u_id
	 * @param search_msg
	 * @return
	 */
	public BaseResponse searchKnowledgesInCollection(String u_id, String search_msg) {

		BaseResponse baseResponse = new BaseResponse();
		String sqlStr = "SELECT * FROM knowledge " + " WHERE k_name LIKE '%" + search_msg + "%' "
				+ " AND k_id IN(SELECT c_k_id FROM collection WHERE c_u_id = " + u_id + ") "
				+ " ORDER BY k_addtime DESC";
		List<Knowledge> knowledges = Knowledge.dao.find(sqlStr);

		if (knowledges.isEmpty()) {
			baseResponse.setResult(ResultCodeEnum.DB_FIND_FAILURE);
		} else {
			baseResponse.setData(knowledges);
			baseResponse.setResult(ResultCodeEnum.DB_FIND_SUCCESS);
		}

		return baseResponse;
	}

	/**
	 * 显示个人知识列表
	 * 
	 * @param u_id
	 * @param k_state
	 * @return
	 */
	public BaseResponse displayPersonalKnowledge(String search_msg, String u_id, String k_state) {

		BaseResponse baseResponse = new BaseResponse();
		String sqlStr = null;

		if (k_state.equals("5")) { // 状态为5时查找所有
			sqlStr = "SELECT * FROM knowledge " + " WHERE k_u_id = " + u_id + " AND k_name LIKE '%" + search_msg + "%' "
					+ " ORDER BY k_addtime DESC";
		} else {
			sqlStr = "SELECT * FROM knowledge " + " WHERE k_u_id = " + u_id + " AND k_state = " + k_state
					+ " AND k_name LIKE '%" + search_msg + "%' " + " ORDER BY k_addtime DESC";
		}
		List<Knowledge> knowledges = Knowledge.dao.find(sqlStr);

		if (knowledges.isEmpty()) {
			baseResponse.setResult(ResultCodeEnum.DB_FIND_FAILURE);
		} else {
			baseResponse.setData(knowledges);
			baseResponse.setResult(ResultCodeEnum.DB_FIND_SUCCESS);
		}

		return baseResponse;
	}

	/**
	 * 用户评论
	 * 
	 * @param u_id
	 * @param k_id
	 * @param com_msg
	 * @return
	 */
	public BaseResponse comment(String u_id, String k_id, String com_msg) {

		BaseResponse baseResponse = new BaseResponse();
		Comment comment = new Comment();
		comment.setComUId(Integer.parseInt(u_id));
		comment.setComKId(Integer.parseInt(k_id));
		comment.setComDesc(com_msg);

		if (comment.save()) { // 评论成功
			baseResponse.setResult(ResultCodeEnum.COMMENT_ADD_SUCCESS);
		} else {
			baseResponse.setResult(ResultCodeEnum.COMMENT_ADD_FAILURE);
		}

		return baseResponse;
	}

	/**
	 * 审核知识（修改知识状态）
	 * 
	 * @param k_id
	 * @param k_state
	 * @return
	 */
	public BaseResponse modifyKnowledgeState(String k_id, String k_state) {

		BaseResponse baseResponse = new BaseResponse();
		SendMail sendMail = new SendMail();
		Knowledge knowledgeToChange = new Knowledge();
		knowledgeToChange = Knowledge.dao.findById(k_id);
		knowledgeToChange.setKState(Integer.parseInt(k_state));
		String f_id = String.valueOf(knowledgeToChange.getKFId());
		if (knowledgeToChange.update()) { // 更新成功，向提交知识的用户发送邮件提示
			esClient.update(f_id, k_id, "", "", k_state);// 同时更改es服务器上知识的审核状态
			String k_name = knowledgeToChange.getKName();
			int u_id = knowledgeToChange.getKUId();
			User user = User.dao.findById(u_id);
			String u_name = user.getUName();
			String u_mail = user.getUEmail();
			String content = null;
			if (k_state.equals("2")) {
				content = "您好，您提交的知识“" + k_name + "”已经审核通过，请登录系统查看。";
			} else if (k_state.equals("3")) {
				content = "抱歉，您提交的知识“" + k_name + "”审核未通过，请登录系统重新提交申请。";
			}
			sendMail.sendingMail(u_name, u_mail, content);

			baseResponse.setResult(ResultCodeEnum.STATE_CHANGE_SUCESS);
		} else {
			baseResponse.setResult(ResultCodeEnum.STATE_CHANGE_FAILURE_UPDATE_DB_ERROE);
		}

		return baseResponse;
	}

	/**
	 * 添加用户（密码默认，权限默认为1）
	 * 
	 * @param u_name
	 * @param u_gender
	 * @param u_phone
	 * @param u_age
	 * @param u_mail
	 * @return
	 */
	public BaseResponse addUser(String u_name, String u_gender, String u_phone, String u_age, String u_mail,
			String u_firm) {

		BaseResponse baseResponse = new BaseResponse();

		// 找出所有用户的邮箱
		List<User> usermails = User.dao.find("SELECT u_email FROM user");
		System.out.println(usermails);
		// 设置当前邮箱
		User thisMail = new User().set("u_email", u_mail);
		// 判断邮箱是否存在
		boolean exist = usermails.contains(thisMail);

		if (exist) { // 邮箱已经存在，添加用户失败
			baseResponse.setResult(ResultCodeEnum.USER_ADD_FAILURE_MAIL_EXISTED);
		} else { // 邮箱不存在，添加操作
			User userToAdd = new User();
			userToAdd.setUName(u_name);
			userToAdd.setUGender(u_gender);
			userToAdd.setUPhone(u_phone);
			userToAdd.setUEmail(u_mail);
			userToAdd.setUAge(Integer.parseInt(u_age));
			userToAdd.setUFirm(Integer.parseInt(u_firm));
			if (userToAdd.save()) { // 添加成功
				baseResponse.setResult(ResultCodeEnum.USER_ADD_SUCCESS);
			} else {
				baseResponse.setResult(ResultCodeEnum.USER_ADD_FAILURE);
			}
		}

		return baseResponse;
	}

	/**
	 * 查看本公司所有的员工
	 * 
	 * @param f_id
	 * @return
	 */
	public BaseResponse viewAllUsers(String f_id) {

		BaseResponse baseResponse = new BaseResponse();
		List<User> users = User.dao.find("SELECT * FROM `user` WHERE u_firm = ?", f_id);

		if (users.isEmpty()) {
			baseResponse.setResult(ResultCodeEnum.DB_FIND_FAILURE);
		} else {
			baseResponse.setData(users);
			baseResponse.setResult(ResultCodeEnum.DB_FIND_SUCCESS);
		}

		return baseResponse;
	}

	/**
	 * 按角色搜索用户
	 * 
	 * @param search_msg
	 * @param f_id
	 * @param u_role
	 * @return
	 */
	public BaseResponse searchUserByRole(String search_msg, String f_id, String u_role) {

		BaseResponse baseResponse = new BaseResponse();
		String sqlStr = "SELECT * FROM `user` " + " WHERE u_firm = " + f_id + " AND u_role = " + u_role
				+ " AND u_name LIKE '%" + search_msg + "%'";
		List<User> users = User.dao.find(sqlStr);

		if (users.isEmpty()) {
			baseResponse.setResult(ResultCodeEnum.DB_FIND_FAILURE);
		} else {
			baseResponse.setData(users);
			baseResponse.setResult(ResultCodeEnum.DB_FIND_SUCCESS);
		}

		return baseResponse;
	}

	/**
	 * 按审核状态查看知识
	 * 
	 * @param f_id
	 * @param k_state
	 * @return
	 */
	public BaseResponse viewKnowledgesByState(String f_id, String k_state) {

		BaseResponse baseResponse = new BaseResponse();
		String sqlStr = "SELECT * FROM knowledge " + " WHERE k_f_id = " + f_id + " AND k_state = " + k_state;
		List<Knowledge> knowledges = Knowledge.dao.find(sqlStr);

		if (knowledges.isEmpty()) {
			baseResponse.setResult(ResultCodeEnum.DB_FIND_FAILURE);
		} else {
			baseResponse.setData(knowledges);
			baseResponse.setResult(ResultCodeEnum.DB_FIND_SUCCESS);
		}

		return baseResponse;
	}

	/**
	 * 用户上传知识
	 * 
	 * @param u_id
	 * @param f_id
	 * @param k_name
	 * @param labels
	 * @param uploadFile
	 * @return
	 */
	public BaseResponse uploadKnowledge(String u_id, String f_id, String k_name, String[] labels,
			UploadFile uploadFile) {

		BaseResponse baseResponse = new BaseResponse();
		OfficeDoc2PDF officeDoc2PDF = new OfficeDoc2PDF();

		// 修改文件名，防止文件名重复
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		String fileName = uploadFile.getFileName();
		String newFileName = sdf.format(new Date()) + "_" + fileName;
		System.out.println(newFileName);
		String path = "/upload/" + newFileName;
		String absoluteString = PathKit.getWebRootPath() + path;
		File newFile = new File(absoluteString);
		uploadFile.getFile().renameTo(newFile);
		String suffixString = path.substring(path.lastIndexOf('.') + 1);

		// 根据文件类别对文件进行分类存储
		Firm firm = Firm.dao.findById(f_id);
		String firmName = firm.getFName();

		List<String> paths = new ArrayList<String>();
		String documentPath = null;
		for (String labelId : labels) {
			Label label = Label.dao.findById(labelId);
			String labelName = label.getLName();
			String filePath = "/upload/" + firmName + "/" + labelName + "/" + newFileName;
			System.out.println(filePath);
			paths.add(filePath);
			File newFile2 = new File(PathKit.getWebRootPath() + filePath);
			try {
				FileUtils.copyFile(newFile, newFile2);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			documentPath = filePath;
		}
		System.out.println("文件路径：" + documentPath);
		String knowledgePath = documentPath;
		System.out.println("文件路径：" + knowledgePath);

		// 判断文件是否为office文档，如果是，调用openoffice进行转换
		String newPathString = documentPath;
		if (suffixString.equals("doc") || suffixString.equals("docx") || suffixString.equals("xls")
				|| suffixString.equals("xlsx") || suffixString.equals("ppt") || suffixString.equals("pptx")) {
			newPathString = documentPath.substring(0, documentPath.lastIndexOf('.')) + ".pdf";
			officeDoc2PDF.officeOpenPDF(absoluteString, PathKit.getWebRootPath() + newPathString);
			paths.add(newPathString);
		}

//		// 为上传的文件创建索引
//		POIUtil.createIndex(knowledgePath);

		boolean flag = newFile.delete();
		System.out.println(flag);
		System.out.println(labels);

		// 对数据库进行操作，将知识存入知识表中，并在类别表中添加相应的记录
		String newPathString2 = newPathString;
		boolean succeed = Db.tx(new IAtom() {
			@Override
			public boolean run() throws SQLException {
				// TODO Auto-generated method stub

				// 找出用户，获取用户权限
				User user = User.dao.findById(u_id);
				int u_role = user.getURole();

				// 在知识表中添加对应记录
				Knowledge knowledge = new Knowledge();
				knowledge.setKUId(Integer.parseInt(u_id));
				knowledge.setKFId(Integer.parseInt(f_id));
				knowledge.setKName(k_name);
				knowledge.setKPath("/KnowledgeLibrary" + knowledgePath);
				knowledge.setKNewpath("/KnowledgeLibrary" + newPathString2);
				// 如果用户为知识管理员或超级管理员或公司管理员，知识状态设置为审核通过
				String k_state = "";
				if (u_role == 3 || u_role == 4 || u_role == 5) {
					knowledge.setKState(2);
					k_state = "2";
				} else {
					k_state = "1";
				}
				if (!knowledge.save()) { // 保存失败回滚事务
					return false;
				}

				System.out.println("k_id:" + knowledge.getKId());

				// 将知识对应的每个标签添加到类别表中
				for (String item : labels) {
					Type type = new Type();
					type.setTKId(knowledge.getKId());
					type.setTLId(Integer.parseInt(item));
					if (!type.save()) {
						return false;
					}
				}

				// 将文件的存储路径保存到数据库中，方便删除时使用
				for (String item : paths) {
					Path path = new Path();
					path.setPKId(knowledge.getKId());
					path.setPPath(item);
					if (!path.save()) {
						return false;
					}
				}

				// 将文件内容添加到ES中，全文搜索时使用
				File file = new File(PathKit.getWebRootPath() + knowledgePath);
				String content = FileContent.getFileContent(file);
				esClient.put(f_id, String.valueOf(knowledge.getKId()), k_name, content, k_state);
				return true;
			}
		});

		if (succeed) {
			baseResponse.setResult(ResultCodeEnum.KNOWLEDGE_UPLOAD_SUCCESS);
		} else {
			baseResponse.setResult(ResultCodeEnum.KNOWLEDGE_UPLOAD_FAILURE);
		}

		return baseResponse;
	}

	/**
	 * 更改知识的信息
	 * 
	 * @param kIdString
	 * @param kNameString
	 * @param kTypeIdStrings
	 * @return
	 */
	public BaseResponse modifyKnowledge(String kIdString, String kNameString, String[] kTypeIdStrings) {

		BaseResponse bResponse = new BaseResponse();

		List<Knowledge> knowledges = Knowledge.dao
				.find("select * from knowledge where k_id = " + "'" + kIdString + "'");
		if (knowledges.size() == 1) {

			Knowledge knowledge = knowledges.get(0);

			boolean succeed = Db.tx(new IAtom() {
				public boolean run() throws SQLException {

					// 删除知识原有的类型
					List<Type> types = Type.dao.find("select * from type where t_k_id = " + "'" + kIdString + "'");

					for (int i = 0; i < types.size(); i++) {

						Type type = types.get(i);
						if (!type.delete())
							return false;

					}
					// 添加知识的类型
					for (String string : kTypeIdStrings) {

						Type type = new Type();
						type.setTKId(Integer.parseInt(kIdString));
						type.setTLId(Integer.parseInt(string));

						if (!type.save())
							return false;
					}
					// 更改知识的名称
					knowledge.setKName(kNameString);
					// 如果用户为知识管理员或超级管理员或公司管理员，知识状态设置为审核通过
					User user = User.dao.findById(knowledge.getKUId());
					int u_role = user.getURole();
					String k_state = "";
					if (u_role == 3 || u_role == 4 || u_role == 5) {
						knowledge.setKState(2);// 审核通过
						k_state = "2";
					} else {
						knowledge.setKState(4);// 更新待审核
						k_state = "4";
					}

					if (!knowledge.update())
						return false;
					esClient.update(String.valueOf(knowledge.getKFId()), kIdString, kNameString, "", k_state);
					return true;
				}
			});

			if (succeed)

				bResponse.setResult(ResultCodeEnum.INFO_UPDATE_SUCESS);
			else

				bResponse.setResult(ResultCodeEnum.DB_SYS_ERROR);

		} else if (knowledges.size() == 0) {
			// 不存在该条记录
			bResponse.setResult(ResultCodeEnum.RECORD_NO_EXIST);
		} else {
			// 数据库错误
			bResponse.setResult(ResultCodeEnum.DB_SYS_ERROR);
		}
		return bResponse;
	}

	/**
	 * @param k_ids
	 * @return
	 */
	public BaseResponse downloadKnowledge(String[] k_ids) {

		BaseResponse baseResponse = new BaseResponse();
		List<DownloadInfo> downloadInfos = new ArrayList<DownloadInfo>();

		boolean succeed = Db.tx(new IAtom() {
			@Override
			public boolean run() throws SQLException {
				// TODO Auto-generated method stub
				Knowledge knowledge = new Knowledge();

				for (String k_id : k_ids) {
					knowledge = Knowledge.dao.findById(k_id);

					DownloadInfo downloadInfo = new DownloadInfo();
					String path = knowledge.getKPath();
					String fileName = path.substring(path.indexOf("_") + 1);
					downloadInfo.setFilePath(path);
					downloadInfo.setFileName(fileName);
					downloadInfos.add(downloadInfo);

					// 下载量+1
					knowledge.setKDownload(knowledge.getKDownload() + 1);
					if (!knowledge.update()) {
						return false;
					}
				}

				return true;
			}
		});

		if (succeed) {
			baseResponse.setData(downloadInfos);
			baseResponse.setResult(ResultCodeEnum.KNOWLEDGE_DOWNLOAD_SUCCESS);
		} else {
			baseResponse.setResult(ResultCodeEnum.KNOWLEDGE_DOWNLOAD_FAILURE);
		}

		return baseResponse;
	}

	/**
	 * 批量删除文件
	 * 
	 * @param kIdStrings
	 * @return
	 */
	public BaseResponse deleteKnowledges(String[] kIdStrings) {

		BaseResponse bResponse = new BaseResponse();

		// 批量删除
		for (String string : kIdStrings) {

			Knowledge knowledge = Knowledge.dao.findById(string);
			List<Path> paths = Path.dao.find("SELECT p_path FROM path WHERE p_k_id = ?", string);
//			// 获取文件路径
//			String kPathString = knowledge.getKPath();
//			String realPathString = kPathString.substring(kPathString.indexOf("/upload"));
//			String completePathString = PathKit.getWebRootPath() + realPathString;

			if (knowledge.delete()) {
				boolean flag = true;
				for (Path path : paths) {
					File file = new File(PathKit.getWebRootPath() + path.getPPath());
					if (file.isFile() && file.exists()) {
						if (!file.delete()) {// 文件删除失败
							bResponse.setResult(ResultCodeEnum.KNOWLEDGE_DELETE_FAILURE_FILE_ERROR);
							flag = false;
							break;
						} else {// 文件删除成功
//							bResponse.setResult(ResultCodeEnum.KNOWLEDGE_DELETE_SUCCESS);
						}
					} else {// 删除失败 文件不存在或其他错误
						bResponse.setResult(ResultCodeEnum.KNOWLEDGE_DELETE_FAILURE_NOT_EXIST);
						flag = false;
						break;
					}
				}
				if (flag) { // 所有的文件都删除成功
					bResponse.setResult(ResultCodeEnum.KNOWLEDGE_DELETE_SUCCESS);
				}
				// 将文件对应的记录从ES服务器中删除
				esClient.delete("knowledge", String.valueOf(knowledge.getKFId()), String.valueOf(knowledge.getKId()));
			} else if (!knowledge.delete()) {
				// 数据库删除失败
				bResponse.setResult(ResultCodeEnum.KNOWLEDGE_DELETE_FAILURE_DB_ERROR);
			}
		}

		return bResponse;
	}

	/**
	 * 知识管理员添加标签
	 * 
	 * @param lFIdString
	 * @param tagString
	 * @return
	 */
	public BaseResponse addLabel(String lFIdString, String tagString) {

		BaseResponse bResponse = new BaseResponse();

		Firm firm = Firm.dao.findById(lFIdString);

		if (firm == null) {
			// 公司不存在
			bResponse.setResult(ResultCodeEnum.LABEL_ADD_FAILURE_FIRM_NOT_EXIST);
		} else if (firm != null) {

			Label label = Label.dao.findFirst(
					"select * from label where l_name = " + "'" + tagString + "'" + "AND l_f_id = " + lFIdString);
			if (label == null) {
				// 标签不存在，可以添加
				Label label2 = new Label();
				label2.setLFId(Integer.parseInt(lFIdString));
				label2.setLName(tagString);

				if (label2.save()) {
					// 标签添加成功
					bResponse.setResult(ResultCodeEnum.LABEL_ADD_SUCCESS);
				} else {
					// 标签添加失败 数据库错误
					bResponse.setResult(ResultCodeEnum.DB_SYS_ERROR);
				}

			} else {
				// 标签已经存在
				bResponse.setResult(ResultCodeEnum.LABEL_ADD_FAILURE_ALREADY_EXIST);
			}
		}
		return bResponse;
	}

	/**
	 * 知识管理员删除标签
	 * 
	 * @param lIdString
	 * @return
	 */
	public BaseResponse deleteLabel(String[] lIdStrings) {

		BaseResponse bResponse = new BaseResponse();

		boolean succeed = Db.tx(new IAtom() {
			public boolean run() throws SQLException {
				for (String lIdString : lIdStrings) {
					Label label = Label.dao.findById(lIdString);
					if (label == null) {
						// 标签不存在
						bResponse.setResult(ResultCodeEnum.LABEL_DELETE_FAILURE_NOT_EXIST);
						return false;
					} else if (label != null) {
						if (!label.delete()) {
							// 标签删除失败 数据库错误
							bResponse.setResult(ResultCodeEnum.DB_SYS_ERROR);
							return false;
						}
					}
				}
				return true;
			}
		});

		if (succeed) {
			// 删除成功
			bResponse.setResult(ResultCodeEnum.LABEL_DELETE_SUCCESS);
		}

		return bResponse;
	}

	/**
	 * 知识管理员修改标签
	 * 
	 * @param lIdString
	 * @param newTagNameString
	 * @return
	 */
	public BaseResponse modifyLabel(String lIdString, String newTagNameString) {

		BaseResponse bResponse = new BaseResponse();

		Label label = Label.dao.findById(lIdString);

		if (label == null) {
			// 标签不存在
			bResponse.setResult(ResultCodeEnum.LABEL_UPDATE_FAILURE_NOT_EXIST);
		} else if (label != null) {
			// 标签存在
			Label label2 = Label.dao.findFirst("select * from label where l_name = " + "'" + newTagNameString + "'");

			if (label2 != null && !label.equals(label2)) {
				// 标签已经存在
				bResponse.setResult(ResultCodeEnum.LABEL_UPDATE_FAILURE_ALREADY_EXIST);
			} else {

				label.setLName(newTagNameString);
				if (label.update()) {
					// 修改成功
					bResponse.setResult(ResultCodeEnum.LABEL_UPDATE_SUCCESS);
				} else {
					// 数据库错误
					bResponse.setResult(ResultCodeEnum.DB_SYS_ERROR);
				}
			}
		}

		return bResponse;
	}

}
