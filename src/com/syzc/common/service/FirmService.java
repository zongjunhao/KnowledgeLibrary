package com.syzc.common.service;

import java.sql.SQLException;
import java.util.List;

import com.jfinal.kit.StrKit;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.IAtom;
import com.syzc.common.kit.BaseResponse;
import com.syzc.common.kit.ResultCodeEnum;
import com.syzc.common.model.Firm;
import com.syzc.common.model.Knowledge;
import com.syzc.common.model.Label;
import com.syzc.common.model.Type;
import com.syzc.common.model.User;

public class FirmService {

	/**
	 * 公司注册
	 * 
	 * @param f_name
	 * @param f_corporation
	 * @param u_name
	 * @param u_mail
	 * @param u_pwd
	 * @return
	 */
	public BaseResponse register(String f_name, String f_corporation, String u_name, String u_mail, String u_pwd) {
		BaseResponse baseResponse = new BaseResponse();

		List<Firm> firms = Firm.dao.find("select * from firm where f_name = " + "'" + f_name + "'");
		List<User> users = User.dao.find("select * from user where u_email = " + "'" + u_mail + "'");
		if (firms.size() == 1) {
			// 公司已经注册
			baseResponse.setResult(ResultCodeEnum.REGISTER_FAILURE_NAME_EXIST);
		} else if (users.size() == 1) {
			// 用户邮箱已经被注册
			baseResponse.setResult(ResultCodeEnum.REGISTER_FAILURE_USER_MAIL_EXIST);
		} else {
			boolean succeed = Db.tx(new IAtom() {
				@Override
				public boolean run() throws SQLException {
					// TODO Auto-generated method stub

					// 保存公司信息
					Firm firm = new Firm();
					firm.setFName(f_name);
					firm.setFCorporation(f_corporation);
					if (!firm.save()) {
						return false;
					}

					// 为公司生成默认标签
					int firmID = firm.getFId();
					String[] labels = { "教育", "娱乐", "生活", "科技", "金融", "计算机" };
					for (String label : labels) {
						Label labelModel = new Label();
						labelModel.setLName(label);
						labelModel.setLFId(firmID);
						if (!labelModel.save()) {
							return false;
						}
					}

					// 保存管理员信息
					User user = new User();
					user.setUName(u_name);
					user.setUEmail(u_mail);
					user.setUPwd(u_pwd);
					user.setUFirm(firmID);
					user.setURole(5);
					if (!user.save()) {
						return false;
					}

					return true;
				}
			});

			if (succeed) {
				baseResponse.setResult(ResultCodeEnum.REGISTER_SUCCESS);
			} else {
				baseResponse.setResult(ResultCodeEnum.REGISTER_FAILURE_SYSTEM_ERROR);
			}
		}

		return baseResponse;
	}

	/**
	 * 公司账号登录
	 * 
	 * @param fMailString
	 * @param fPwdString
	 * @return
	 */
	public BaseResponse login(String fMailString, String fPwdString) {

		BaseResponse bResponse = new BaseResponse();

		if (StrKit.isBlank(fMailString) || StrKit.isBlank(fPwdString)) {

			bResponse.setResult(ResultCodeEnum.NO_ENOUGH_MES); // 登录失败，账号或密码为空
		} else {
			// 仅审核通过的账号才可登录
			List<Firm> list = Firm.dao.find("select * from firm where f_mail = " + "'" + fMailString + "'");

			if (list.size() == 1) {

				Firm firm = list.get(0);
				int fState = firm.getFState();
				if (fState == 2) {
					// 账号审核通过
					if (firm.getFPassword().equals(fPwdString)) {
						bResponse.setData(firm);
						bResponse.setResult(ResultCodeEnum.LOGIN_SUCCESS); // 登录成功
					} else {
						bResponse.setResult(ResultCodeEnum.LOGIN_ERROR); // 登录失败，账号或密码错误
					}
				} else if (fState == 1) {
					// 账号未审核
					bResponse.setResult(ResultCodeEnum.LOGIN_FAILURE_NO_AUDIT);
				} else if (fState == 3) {
					// 账号审核不通过
					bResponse.setResult(ResultCodeEnum.LOGIN_FAILURE_AUDIT_NOT_PASS);
				} else {
					// 未知的错误
					bResponse.setResult(ResultCodeEnum.UNKOWN_ERROE);
				}
			} else if (list.size() == 0) {

				bResponse.setResult(ResultCodeEnum.NO_EXIST_USER); // 登录失败，用户不存在
			} else {
				// 系统故障，未知的错误
				bResponse.setResult(ResultCodeEnum.UNKOWN_ERROE);
			}
		}

		return bResponse;

	}

	/**
	 * 更改公司信息
	 * 
	 * @param fIdString
	 * @param newNameString
	 * @param newCorporationString
	 * @param newCodeString
	 * @param newPhoneString
	 * @param newAddressString
	 * @param newMailString
	 * @param newDescString
	 * @return
	 */
	public BaseResponse modifyFirmInfo(String fIdString, String newNameString, String newCorporationString,
			String newCodeString, String newPhoneString, String newAddressString, String newMailString,
			String newDescString) {

		BaseResponse bResponse = new BaseResponse();

		// 首先检查该公司是否存在
		List<Firm> firms = Firm.dao.find("select * from firm where f_id = " + "'" + fIdString + "'");
		if (firms.size() == 1) {
			// 检查邮箱和企业名是否唯一
			List<Firm> sameNameFirms = Firm.dao.find("select f_name from firm");
			List<Firm> sameMailFirms = Firm.dao.find("select f_mail from firm");

			Firm thisNameFirm = new Firm().set("f_mail", newMailString);
			boolean isNameExist = sameNameFirms.contains(thisNameFirm);
			Firm thisMailFirm = new Firm().set("f_mail", newMailString);
			boolean isMailExist = sameMailFirms.contains(thisMailFirm);
			// 待修改公司
			Firm firm = firms.get(0);
			if ((isNameExist && !newNameString.equals(firm.getFName()))
					|| (isMailExist && !newMailString.equals(firm.getFMail()))) {
				// 修改失败 邮箱或企业名已占用
				bResponse.setResult(ResultCodeEnum.UPDATE_FAILURE_MAIL_NAME_EXIST);

			} else {
				// 可以修改
				firm.setFName(newNameString);
				firm.setFMail(newMailString);
				firm.setFCorporation(newCorporationString);
				firm.setFCode(newCodeString);
				firm.setFPhone(newPhoneString);
				firm.setFAddress(newAddressString);
				firm.setFDesc(newDescString);

				// 提交修改
				if (firm.update()) {
					// 信息修改成功
					bResponse.setResult(ResultCodeEnum.INFO_UPDATE_SUCESS);
				} else {
					// 未知的系统错误
					bResponse.setResult(ResultCodeEnum.UNKOWN_ERROE);
				}
			}
		} else if (firms.size() == 0) {
			// 待修改公司不存在
			bResponse.setResult(ResultCodeEnum.UPDATE_FAILURE_FIRM_NOT_EXIST);
		} else {
			// 数据库系统错误
			bResponse.setResult(ResultCodeEnum.DB_SYS_ERROR);
		}

		return bResponse;
	}

	/**
	 * 公司添加用户，密码默认123456
	 * 
	 * @param uNameString
	 * @param uGenderString
	 * @param uAgeString
	 * @param uMailString
	 * @param uPhoneString
	 * @param uFirmString
	 * @param uRoleString
	 * @return
	 */
	public BaseResponse addUser(String uNameString, String uGenderString, String uAgeString, String uMailString,
			String uPhoneString, String uFirmString, String uRoleString) {

		BaseResponse bResponse = new BaseResponse();

		List<User> users = User.dao.find("select * from user where u_email = " + "'" + uMailString + "'");

		if (users.size() == 0) {

			User user = new User();
			user.setUName(uNameString);
			user.setURole(Integer.parseInt(uRoleString));
			user.setUEmail(uMailString);
			user.setUAge(Integer.parseInt(uAgeString));
			user.setUFirm(Integer.parseInt(uFirmString));
			user.setUGender(uGenderString);
			user.setUPhone(uPhoneString);

			if (user.save()) {
				// 用户添加成功
				bResponse.setResult(ResultCodeEnum.USER_ADD_SUCCESS);
			} else {
				// 用户添加失败，数据库故障
				bResponse.setResult(ResultCodeEnum.DB_SYS_ERROR);
			}

		} else if (users.size() == 1) {
			// 邮箱已经存在
			bResponse.setResult(ResultCodeEnum.USER_ADD_FAILURE_MAIL_EXISTED);
		} else {
			// 数据库错误
			bResponse.setResult(ResultCodeEnum.DB_SYS_ERROR);
		}

		return bResponse;
	}

	/**
	 * 查找某公司的所有用户
	 * 
	 * @param fIdString
	 * @return
	 */
	public BaseResponse viewAllUserInfo(String fIdString) {

		BaseResponse bResponse = new BaseResponse();

		List<User> users = User.dao.find("select * from user where u_firm = " + "'" + fIdString + "'");
		if (users.size() == 0) {
			// 查找失败，没有记录
			bResponse.setResult(ResultCodeEnum.DB_FIND_FAILURE);
		} else if (users.size() > 0) {
			// 查找成功
			bResponse.setData(users);
			bResponse.setResult(ResultCodeEnum.DB_FIND_SUCCESS);
		} else {
			// 未知的错误
			bResponse.setResult(ResultCodeEnum.UNKOWN_ERROE);
		}

		return bResponse;
	}

	public BaseResponse modifyUserInfo(String uIdString, String uNameString, String uRoleString, String uGenderString,
			String uPhoneString, String uAgeString, String uMailString) {

		BaseResponse bResponse = new BaseResponse();

		List<User> users1 = User.dao.find("select * from user where u_id = " + "'" + uIdString + "'");

		// 用户不为空
		if (users1.size() == 1) {
			User user = users1.get(0);
			List<User> users = User.dao.find("select * from user where u_email = " + "'" + uMailString + "'");

			if (users.size() == 0 || (users.size() == 1 && users.get(0).equals(user))) {

				user.setUName(uNameString);
				user.setUGender(uGenderString);
				user.setUPhone(uPhoneString);
				user.setUAge(Integer.parseInt(uAgeString));
				user.setUEmail(uMailString);
				user.setURole(Integer.parseInt(uRoleString));

				if (user.update()) {
					// 角色更改成功
					bResponse.setResult(ResultCodeEnum.ROLE_UPDATE_SUCCESS);
				} else {
					// 更改失败 数据库错误
					bResponse.setResult(ResultCodeEnum.ROLE_UPDATE_FAILURE);
				}
			} else if (users.size() == 1) {
				// 邮箱已被占用
				bResponse.setResult(ResultCodeEnum.UPDATE_FAILURE_MAIL_EXISTED);
			} else {
				// 数据库错误
				bResponse.setResult(ResultCodeEnum.DB_SYS_ERROR);
			}
		} else if (users1.size() == 0) {
			// 未找到用户
			bResponse.setResult(ResultCodeEnum.ROLE_UPDATE_FAILURE_NO_USER);
		} else {
			// 未知的错误
			bResponse.setResult(ResultCodeEnum.UNKOWN_ERROE);
		}

		return bResponse;
	}

	/**
	 * 删除用户
	 * 
	 * @param uIdString
	 * @return
	 */
	public BaseResponse dropUser(String uIdString) {

		BaseResponse bResponse = new BaseResponse();

		if (!StrKit.isBlank(uIdString)) {

			List<User> users = User.dao.find("select * from user where u_id = " + "'" + uIdString + "'");
			if (users.size() == 0) {
				// 用户不存在
				bResponse.setResult(ResultCodeEnum.USER_DELETE_FAILURE_USER_NOT_EXIST);
			} else if (users.size() == 1) {

				User user = users.get(0);
				if (user.delete()) {
					// 删除用户成功
					bResponse.setResult(ResultCodeEnum.USER_DELETE_SUCCESS);
				} else {
					// 用户删除失败 数据库错误
					bResponse.setResult(ResultCodeEnum.USER_DELETE_FAILURE_DB_ERROR);
				}
			} else {
				// 数据库故障
				bResponse.setResult(ResultCodeEnum.USER_DELETE_FAILURE_DB_ERROR);
			}
		} else if (StrKit.isBlank(uIdString)) {
			// 页面请求参数错误
			bResponse.setResult(ResultCodeEnum.REQUEST_NO_PARAM_ID_ERROR);
		} else {
			// 未知的系统错误
			bResponse.setResult(ResultCodeEnum.UNKOWN_ERROE);
		}
		return bResponse;
	}

	public BaseResponse viewAllKnowledge() {

		BaseResponse bResponse = new BaseResponse();

		return bResponse;
	}

	/**
	 * 搜索知识，返回以某种方式排序的符合条件（不按类别，全部）的所有知识
	 * 
	 * @param search_msg
	 * @param f_id
	 * @param orderc
	 * @return
	 */
	public BaseResponse searchKnowledges(String search_msg, String f_id, String order) {

		BaseResponse baseResponse = new BaseResponse();
		String sqlStr = "SELECT * FROM knowledge " + " WHERE k_f_id = " + f_id + " AND k_state = 2"
				+ " AND k_name LIKE '%" + search_msg + "%' " + " ORDER BY " + order + " DESC";
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
	 * 搜索知识，返回以某种方式排序的符合条件（按类别，全部）的所有知识
	 * 
	 * @param search_msg
	 * @param f_id
	 * @param order
	 * @param l_id
	 * @return
	 */
	public BaseResponse searchKnowledgesByLabel(String search_msg, String f_id, String order, String l_id) {

		BaseResponse baseResponse = new BaseResponse();
		String sqlStr = "SELECT * FROM knowledge " + " WHERE k_f_id = " + f_id + " AND k_state = 2 "
				+ " AND k_name LIKE '%" + search_msg + "%' " + " AND k_id IN(SELECT t_k_id FROM type WHERE t_l_id = "
				+ l_id + " )" + " ORDER BY " + order + " DESC";
		List<Knowledge> knowledges = Knowledge.dao.find(sqlStr);

		if (knowledges.isEmpty()) {
			baseResponse.setResult(ResultCodeEnum.DB_FIND_FAILURE);
		} else {
			baseResponse.setData(knowledges);
			baseResponse.setResult(ResultCodeEnum.DB_FIND_SUCCESS);
		}

		return baseResponse;
	}

	public BaseResponse viewAllKnowledgesByLabel(String fIdString, String orderString, String lIdString) {

		BaseResponse bResponse = new BaseResponse();

		String sqlString = "select * from knowledge where k_f_id = " + "'" + fIdString + "'" + "and k_id in ("
				+ "select t_k_id from type where t_l_id = " + "'" + lIdString + "'" + ")" + "order by " + "'"
				+ orderString + "'";
		List<Knowledge> knowledges = Knowledge.dao.find(sqlString);

		if (!knowledges.isEmpty()) {
			bResponse.setData(knowledges);
			bResponse.setResult(ResultCodeEnum.DB_FIND_SUCCESS);
		} else {
			bResponse.setResult(ResultCodeEnum.DB_FIND_FAILURE);
		}

		return bResponse;
	}
}
