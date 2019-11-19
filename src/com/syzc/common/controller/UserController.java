package com.syzc.common.controller;

import com.jfinal.core.Controller;
import com.jfinal.kit.StrKit;
import com.jfinal.upload.UploadFile;
import com.syzc.common.kit.BaseResponse;
import com.syzc.common.kit.ResultCodeEnum;
import com.syzc.common.service.UserService;

public class UserController extends Controller {
	public static UserService userService = new UserService();

	public void index() {
		renderText("UserController");
	}

//	验证码图片
	public void pic() {
		renderCaptcha();
	}

//	登录
	public void login() {
		BaseResponse baseResponse = new BaseResponse();
		// 验证码是否正确
		boolean result = validateCaptcha("inputRandomCode");
		if (result) {
			System.out.println("验证码正确");
			String u_mail = getPara("u_mail");
			String u_pwd = getPara("u_pwd");
			
//			if (getSessionAttr(u_mail) != null && getSessionAttr(u_mail).equals("ready")) {
//				// 账号已经登录
//				baseResponse.setResult(ResultCodeEnum.LOGIN_SUCCESS);
//			} else {
				
				baseResponse = userService.login(u_mail, u_pwd);
//			}

			if (baseResponse.getResultCode().equals("4000")) {
				setSessionAttr(u_mail, "ready");
				System.out.println("用户" + u_mail + "的登陆状态是ready");
			} else {
				setSessionAttr(u_mail, "unready");
				System.out.println("用户" + u_mail + "的登陆状态是unready");
			}
		} else {
			System.out.println("验证码错误");
			baseResponse.setResult(ResultCodeEnum.LOGIN_FAILURE_CODE_ERROR);
		}
		renderJson(baseResponse);
	}

//	退出登录
	public void logout() {
		BaseResponse baseResponse = new BaseResponse();
		String u_mail = getPara("u_mail");

		if (getSessionAttr(u_mail) != null && getSessionAttr(u_mail).equals("ready")) {
			removeSessionAttr(u_mail);
			System.out.println("用户" + u_mail + "退出登录成功");
			baseResponse.setResult(ResultCodeEnum.LOGOUT_SUCCESS);
		} else {
			System.out.println("该用户未登录");
			baseResponse.setResult(ResultCodeEnum.NO_LOGIN_USER);
		}

		renderJson(baseResponse);
	}

//	查看用户详细信息
	public void viewUserInfo() {
		BaseResponse baseResponse = new BaseResponse();
		String u_id = getPara("u_id");
		baseResponse = userService.viewUserInfo(u_id);
		renderJson(baseResponse);
	}

//	修改用户信息
	public void modifyUserInfo() {
		BaseResponse baseResponse = new BaseResponse();
		String u_id = getPara("u_id");
		String u_name = getPara("u_name");
		String u_pwd = getPara("u_pwd");
		String u_gender = getPara("u_gender");
		String u_phone = getPara("u_phone");
		String u_age = getPara("u_age");
		String u_mail = getPara("u_mail");
		baseResponse = userService.modifyUserInfo(u_id, u_name, u_pwd, u_gender, u_phone, u_age, u_mail);
		renderJson(baseResponse);
	}

//	查看所有标签
	public void viewLabels() {
		BaseResponse baseResponse = new BaseResponse();
		String f_id = getPara("f_id");
		baseResponse = userService.viewLabels(f_id);
		renderJson(baseResponse);
	}

//	返回某一类别的审核已通过的所有知识（排序方式默认）
	public void viewAllKnowledge() {
		BaseResponse baseResponse = new BaseResponse();
		String f_id = getPara("f_id");
		String l_id = getPara("l_id");
		String uIdString = getPara("u_id");
		baseResponse = userService.viewAllKnowledge(f_id, l_id, uIdString);
		renderJson(baseResponse);
	}

//	查看某一特定知识的详细信息
	public void viewSpecificKnowledge() {
		BaseResponse baseResponse = new BaseResponse();
		String k_id = getPara("k_id");
		String u_id = getPara("u_id");
		baseResponse = userService.viewSpecificKnowledge(k_id, u_id);
		renderJson(baseResponse);
	}

//	返回以某种方式排序的符合条件（不按类别，全部）的所有知识
	public void searchKnowledges() {
		BaseResponse baseResponse = new BaseResponse();
		String search_msg = getPara("search_msg");
		String f_id = getPara("f_id");
		String order = getPara("order");
		String uIdString = getPara("u_id");
		baseResponse = userService.searchKnowledges(search_msg, f_id, order, uIdString);
		renderJson(baseResponse);
	}

//	返回以某种方式排序的符合条件（按类别，全部）的所有知识
	public void searchKnowledgesByLabel() {
		BaseResponse baseResponse = new BaseResponse();
		String search_msg = getPara("search_msg");
		String f_id = getPara("f_id");
		String order = getPara("order");
		String l_id = getPara("l_id");
		String uIdString = getPara("u_id");
		baseResponse = userService.searchKnowledgesByLabel(search_msg, f_id, order, l_id, uIdString);
		renderJson(baseResponse);
	}

//	用户收藏知识
	public void collect() {
		BaseResponse baseResponse = new BaseResponse();
		String u_id = getPara("u_id");
		String k_id = getPara("k_id");
		baseResponse = userService.collect(u_id, k_id);
		renderJson(baseResponse);
	}

//	删除用户收藏夹内的知识
	public void deleteCollections() {
		BaseResponse baseResponse = new BaseResponse();
		String u_id = getPara("u_id");
		String[] k_id = getParaValues("k_id");
		baseResponse = userService.deleteCollections(u_id, k_id);
		renderJson(baseResponse);
	}

//	显示用户收藏夹列表
	public void displayCollections() {
		BaseResponse baseResponse = new BaseResponse();
		String u_id = getPara("u_id");
		baseResponse = userService.displayCollections(u_id);
		renderJson(baseResponse);
	}

//	在用户收藏夹内搜索知识
	public void searchKnowledgesInCollection() {
		BaseResponse baseResponse = new BaseResponse();
		String u_id = getPara("u_id");
		String search_msg = getPara("search_msg");
		baseResponse = userService.searchKnowledgesInCollection(u_id, search_msg);
		renderJson(baseResponse);
	}

//	显示个人知识列表
	public void displayPersonalKnowledge() {
		BaseResponse baseResponse = new BaseResponse();
		String search_msg = getPara("search_msg");
		String u_id = getPara("u_id");
		String k_state = getPara("k_state");
		baseResponse = userService.displayPersonalKnowledge(search_msg, u_id, k_state);
		renderJson(baseResponse);
	}

//	用户评论
	public void comment() {
		BaseResponse baseResponse = new BaseResponse();
		String u_id = getPara("u_id");
		String k_id = getPara("k_id");
		String com_msg = getPara("com_msg");
		baseResponse = userService.comment(u_id, k_id, com_msg);
		renderJson(baseResponse);
	}

//	审核知识（修改知识状态）
	public void modifyKnowledgeState() {
		BaseResponse baseResponse = new BaseResponse();
		String k_id = getPara("k_id");
		String k_state = getPara("k_state");
		baseResponse = userService.modifyKnowledgeState(k_id, k_state);
		renderJson(baseResponse);
	}

//	添加用户（密码默认，权限默认为1）
	public void addUser() {
		BaseResponse baseResponse = new BaseResponse();
		String u_name = getPara("u_name");
		String u_gender = getPara("u_gender");
		String u_phone = getPara("u_phone");
		String u_age = getPara("u_age");
		String u_mail = getPara("u_mail");
		String u_firm = getPara("u_firm");
		baseResponse = userService.addUser(u_name, u_gender, u_phone, u_age, u_mail, u_firm);
		renderJson(baseResponse);
	}

//	查看本公司所有员工
	public void viewAllUsers() {
		BaseResponse baseResponse = new BaseResponse();
		String f_id = getPara("f_id");
		baseResponse = userService.viewAllUsers(f_id);
		renderJson(baseResponse);
	}

//	按角色搜索用户
	public void searchUserByRole() {
		BaseResponse baseResponse = new BaseResponse();
		String search_msg = getPara("search_msg");
		String f_id = getPara("f_id");
		String u_role = getPara("u_role");
		baseResponse = userService.searchUserByRole(search_msg, f_id, u_role);
		renderJson(baseResponse);
	}

//	按审核状态查看知识
	public void viewKnowledgesByState() {
		BaseResponse baseResponse = new BaseResponse();
		String f_id = getPara("f_id");
		String k_state = getPara("k_state");
		baseResponse = userService.viewKnowledgesByState(f_id, k_state);
		renderJson(baseResponse);
	}

//	上传知识
	public void uploadKnowledge() {
		BaseResponse baseResponse = new BaseResponse();
		UploadFile file = getFile("file");
		String u_id = getPara("u_id");
		String f_id = getPara("f_id");
		String k_name = getPara("k_name");
		String k_type = getPara("l_id");
		String[] label = k_type.split(",");
		for (String item : label) {
			System.out.println(item);
		}
//		String[] k_type = getParaValues("l_id");
		System.out.println("--------------------------");
		System.out.println("1" + getPara("l_id"));
		System.out.println("2" + getParaValues("l_id"));
		baseResponse = userService.uploadKnowledge(u_id, f_id, k_name, label, file);
		renderJson(baseResponse);
	}

	/**
	 * 修改知识信息
	 */
	public void modifyKnowledge() {

		BaseResponse bResponse = new BaseResponse();

		String kIdString = getPara("k_id");
		String kNameString = getPara("k_name");
		String kTypeIdString[] = getParaValues("k_typeId");

		if (!StrKit.isBlank(kIdString) && !StrKit.isBlank(kNameString) && kTypeIdString.length > 0) {

			// 进行业务逻辑处理
			bResponse = userService.modifyKnowledge(kIdString, kNameString, kTypeIdString);

		} else if (StrKit.isBlank(kIdString) || StrKit.isBlank(kNameString) || kTypeIdString.length == 0) {
			// 请求的参数有空
			bResponse.setResult(ResultCodeEnum.DB_WORNING_NULL);
		} else {
			// 未知的错误
			bResponse.setResult(ResultCodeEnum.UNKOWN_ERROE);
		}

		renderJson(bResponse);
	}

//	下载知识
	public void downloadKnowledge() {

		BaseResponse baseResponse = new BaseResponse();
		String[] k_ids = getParaValues("k_ids");

		if (StrKit.notBlank(k_ids)) {
			// 不包括空字符串 并且 被赋值 进行业务逻辑处理
			baseResponse = userService.downloadKnowledge(k_ids);
		} else if (!StrKit.notBlank(k_ids)) {
			// 请求的参数为空 空字符串 或者 未被赋值
			baseResponse.setResult(ResultCodeEnum.DB_WORNING_NULL);
		} else {
			// 未知的错误
			baseResponse.setResult(ResultCodeEnum.UNKOWN_ERROE);
		}

		renderJson(baseResponse);
	}

	public void deleteKnowledges() {

		BaseResponse bResponse = new BaseResponse();

		String[] kIdStrings = getParaValues("k_id");

		if (StrKit.notBlank(kIdStrings)) {
			// 不包括空字符串 并且 被赋值 进行业务逻辑处理
			bResponse = userService.deleteKnowledges(kIdStrings);
		} else if (!StrKit.notBlank(kIdStrings)) {
			// 请求的参数为空 包括空字符串 或者 未被赋值
			bResponse.setResult(ResultCodeEnum.DB_WORNING_NULL);
		} else {
			// 未知的错误
			bResponse.setResult(ResultCodeEnum.UNKOWN_ERROE);
		}

		renderJson(bResponse);
	}

	/**
	 * 知识管理员添加标签
	 */
	public void addLabel() {

		BaseResponse bResponse = new BaseResponse();

		String lFIdString = getPara("l_f_id");
		String tagString = getPara("tag");

		if (!StrKit.isBlank(lFIdString) && !StrKit.isBlank(tagString)) {
			// 请求的参数不为空
			bResponse = userService.addLabel(lFIdString, tagString);
		} else if (StrKit.isBlank(lFIdString) || StrKit.isBlank(tagString)) {
			// 请求的参数有空
			bResponse.setResult(ResultCodeEnum.DB_WORNING_NULL);
		} else {
			// 未知的错误
			bResponse.setResult(ResultCodeEnum.UNKOWN_ERROE);
		}

		renderJson(bResponse);
	}

	/**
	 * 知识管理员删除标签
	 */
	public void deleteLabel() {

		BaseResponse bResponse = new BaseResponse();

		String[] lIdStrings = getParaValues("l_id");

		if (StrKit.notBlank(lIdStrings)) {
			// 请求的参数不为空
			bResponse = userService.deleteLabel(lIdStrings);
		} else if (!StrKit.notBlank(lIdStrings)) {
			// 请求的参数有空
			bResponse.setResult(ResultCodeEnum.DB_WORNING_NULL);
		} else {
			// 未知的错误
			bResponse.setResult(ResultCodeEnum.UNKOWN_ERROE);
		}

		renderJson(bResponse);
	}

	/**
	 * 知识管理员修改标签
	 */
	public void modifyLabel() {

		BaseResponse bResponse = new BaseResponse();

		String lIdString = getPara("l_id");
		String newTagNameString = getPara("newTagName");

		if (!StrKit.isBlank(lIdString) && !StrKit.isBlank(newTagNameString)) {
			// 请求的参数不为空
			bResponse = userService.modifyLabel(lIdString, newTagNameString);
		} else if (StrKit.isBlank(lIdString) || StrKit.isBlank(newTagNameString)) {
			// 请求的参数有空
			bResponse.setResult(ResultCodeEnum.DB_WORNING_NULL);
		} else {
			// 未知的错误
			bResponse.setResult(ResultCodeEnum.UNKOWN_ERROE);
		}

		renderJson(bResponse);
	}

}
