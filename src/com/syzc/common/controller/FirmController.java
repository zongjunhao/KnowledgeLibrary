package com.syzc.common.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import com.jfinal.core.Controller;
import com.jfinal.kit.StrKit;
import com.syzc.common.kit.BaseResponse;
import com.syzc.common.kit.ResultCodeEnum;
import com.syzc.common.kit.SendMail;
import com.syzc.common.service.FirmService;

public class FirmController extends Controller {

	public static FirmService firmService = new FirmService();
	public static Map<String, String> mailCode = new HashMap<String, String>();
//	BaseResponse bResponse = new BaseResponse();

//	public void index() {
//		renderText("FirmController");
//	}

//	验证码图片
	public void pic() {
		renderCaptcha();
	}

	public void mailConfirm() {
		BaseResponse baseResponse = new BaseResponse();
		SendMail sendMail = new SendMail();
		StringBuilder str = new StringBuilder();
		Random random = new Random();

		String f_mail = getPara("f_mail");
		for (int i = 0; i < 6; i++) {
			str.append(random.nextInt(10));
		}
		String confirmCode = str.toString();
		System.out.println(confirmCode);
		String content = "欢迎注册知识管理系统，您的验证码是“" + confirmCode + "”,请将验证码填写至注册页面。若非本人操作，请忽略此邮件。";
		boolean succeed = sendMail.sendingMail(f_mail, f_mail, content);
		if (succeed) {
			baseResponse.setResult(ResultCodeEnum.CONFIRMCODE_SEND_SUCCESS);
		} else {
			baseResponse.setResult(ResultCodeEnum.CONFIRMCODE_SEND_FAILURE);
		}
		mailCode.put(f_mail, confirmCode);
		System.out.println(mailCode.get(f_mail));
		System.out.println(mailCode);
		renderJson(baseResponse);
	}

	public void register() {
		BaseResponse baseResponse = new BaseResponse();
		String f_name = getPara("f_name");
		String f_corporation = getPara("f_corporation");
		String u_name = getPara("u_name");
		String u_mail = getPara("u_mail");
		String confirmCode = getPara("confirmCode");
		String u_pwd = getPara("u_pwd");

		String realCode = mailCode.get(u_mail);
		System.out.println(mailCode);
		mailCode.remove(u_mail);
		System.out.println(mailCode);
		System.out.println(realCode);
		if (realCode.equals(confirmCode)) {
			baseResponse = firmService.register(f_name, f_corporation, u_name, u_mail, u_pwd);
		} else {
			baseResponse.setResult(ResultCodeEnum.REGISTER_FAILURE_CONFIRMCODE_ERROR);
		}

		renderJson(baseResponse);
	}

//	/**
//	 * 公司注册
//	 */
//	public void register1() {
//
//		BaseResponse bResponse = new BaseResponse();
//
//		String fNameString = getPara("f_name");
//		String fAddressString = getPara("f_address");
//		String fMailString = getPara("f_mail");
//		String fCorporationString = getPara("f_corporation");
//		String fCodeString = getPara("f_code");
//		String fPhoneString = getPara("f_phone");
//		String fDescString = getPara("f_desc"); // 公司描述，可以为空
//		String fPasswordString = getPara("f_password");
//		String fPConfirmString = getPara("f_p_confirm");
//		String confirmCode = getPara("confirmCode");
//
//		String realCode = mailCode.get(fMailString);
//		System.out.println(mailCode);
//		mailCode.remove(fMailString);
//		System.out.println(mailCode);
//		System.out.println(realCode);
//		if (realCode.equals(confirmCode)) {
//			if (!StrKit.isBlank(fNameString) && !StrKit.isBlank(fAddressString) && !StrKit.isBlank(fMailString)
//					&& !StrKit.isBlank(fCorporationString) && !StrKit.isBlank(fCodeString) && !StrKit.isBlank(fPhoneString)
//					&& !StrKit.isBlank(fPasswordString) && !StrKit.isBlank(fPConfirmString)) {
//				if (fCodeString.length() <= 20 && fCodeString.length() > 0) {
//
//					if (fPasswordString.equals(fPConfirmString)) {
//
//						bResponse = firmService.register(fNameString, fAddressString, fMailString, fCorporationString,
//								fPhoneString, fDescString, fPasswordString, fCodeString);
//					} else {
//						// 两次密码不一致
//						bResponse.setResult(ResultCodeEnum.REGISTER_FAILURE_PASSWORD_DIFFERENT);
//					}
//				} else {
//					// 社会信用代码过长或错误 页面请求参数错误
//					bResponse.setResult(ResultCodeEnum.REQUEST_NO_PARAM_ID_ERROR);
//				}
//
//			} else if (StrKit.isBlank(fNameString) || StrKit.isBlank(fAddressString) || StrKit.isBlank(fMailString)
//					|| StrKit.isBlank(fCorporationString) || StrKit.isBlank(fCodeString) || StrKit.isBlank(fPhoneString)
//					|| StrKit.isBlank(fPasswordString) || StrKit.isBlank(fPConfirmString)) {
//				// 请求参数有空
//				bResponse.setResult(ResultCodeEnum.REGISTER_FAILURE_NO_ENOUGH_MES);
//			} else {
//				// 其它未知错误
//				bResponse.setResult(ResultCodeEnum.UNKOWN_ERROE);
//			}
//		} else {
//			bResponse.setResult(ResultCodeEnum.REGISTER_FAILURE_CONFIRMCODE_ERROR);
//		}
//
//		renderJson(bResponse);
//	}

	/**
	 * 公司登录
	 */
	public void login() {

		BaseResponse bResponse = new BaseResponse();
		boolean result = validateCaptcha("inputRandomCode");
		if (result) {
			System.out.println("验证码正确");
			String fMailString = getPara("f_mail");
			String fPwdString = getPara("f_pwd");

			if (!StrKit.isBlank(fMailString) && !StrKit.isBlank(fPwdString)) {

//				if (getSessionAttr(fMailString) != null && getSessionAttr(fMailString).equals("ready")) {
//					// 账号已经登录
//					bResponse.setResult(ResultCodeEnum.LOGIN_SUCCESS);
//				} else {

				bResponse = firmService.login(fMailString, fPwdString);
//				}

				if (bResponse.getResultCode().equals("4000")) {

					setSessionAttr(fMailString, "ready");
				} else {

					setSessionAttr(fMailString, "unready");
				}

			} else {
				
				bResponse.setResult(ResultCodeEnum.NO_ENOUGH_MES);
			}
		} else {
			System.out.println("验证码错误");
			bResponse.setResult(ResultCodeEnum.LOGIN_FAILURE_CODE_ERROR);
		}

		renderJson(bResponse);

	}

	/**
	 * 企业管理员退出登录
	 */
	public void logout() {

		BaseResponse bResponse = new BaseResponse();

		String fMailString = getPara("f_mail");

		if (getSessionAttr(fMailString) != null && getSessionAttr(fMailString).equals("ready")) {

			removeSessionAttr(fMailString);
			System.out.println("用户" + fMailString + "退出登录成功");
			bResponse.setResult(ResultCodeEnum.LOGOUT_SUCCESS);
		} else {

			System.out.println("该用户未登录");
			bResponse.setResult(ResultCodeEnum.NO_LOGIN_USER);
		}

		renderJson(bResponse);
	}

	/**
	 * 公司修改信息
	 */
	public void modifyFirmInfo() {

		BaseResponse bResponse = new BaseResponse();

		String fIdString = getPara("f_id");
		String newNameString = getPara("newName");
		String newCorporationString = getPara("newCorporation");
		String newCodeString = getPara("newCode");
		String newPhoneString = getPara("newPhone");
		String newAddressString = getPara("newAddress");
		String newMailString = getPara("newMail");
		String newDescString = getPara("newDesc");

		if (StrKit.isBlank(fIdString)) {
			// 页面未正确传入参数 f_id
			bResponse.setResult(ResultCodeEnum.REQUEST_NO_PARAM_ID_ERROR);
		} else if (!StrKit.isBlank(fIdString)) {
			// 除公司描述外，均不能为空
			if (!StrKit.isBlank(newNameString) && !StrKit.isBlank(newCorporationString)
					&& !StrKit.isBlank(newCodeString) && !StrKit.isBlank(newPhoneString)
					&& !StrKit.isBlank(newAddressString) && !StrKit.isBlank(newMailString)) {

				bResponse = firmService.modifyFirmInfo(fIdString, newNameString, newCorporationString, newCodeString,
						newPhoneString, newAddressString, newMailString, newDescString);

			} else if (StrKit.isBlank(newNameString) || StrKit.isBlank(newCorporationString)
					|| StrKit.isBlank(newCodeString) || StrKit.isBlank(newPhoneString)
					|| StrKit.isBlank(newAddressString) || StrKit.isBlank(newMailString)) {
				// 请求参数不足
				bResponse.setResult(ResultCodeEnum.UPDATE_FAILURE_NO_ENOUGH_MES);
			} else {
				// 未知的错误
				bResponse.setResult(ResultCodeEnum.UNKOWN_ERROE);
			}
		}

		renderJson(bResponse);
	}

	/**
	 * 添加用户
	 */
	public void addUser() {

		BaseResponse bResponse = new BaseResponse();

		String uNameString = getPara("u_name");
		String uGenderString = getPara("u_gender");
		String uPhoneString = getPara("u_phone");
		String uMailString = getPara("u_mail");
		String uRoleString = getPara("u_role");
		String uFirmString = getPara("u_firm");
		String uAgeString = getPara("u_age");

		if (!StrKit.isBlank(uNameString) && !StrKit.isBlank(uGenderString) && !StrKit.isBlank(uPhoneString)
				&& !StrKit.isBlank(uMailString) && !StrKit.isBlank(uRoleString) && !StrKit.isBlank(uFirmString)
				&& !StrKit.isBlank(uAgeString)) {

			if (uRoleString.equals("1") || uRoleString.equals("2") || uRoleString.equals("3")
					|| uRoleString.equals("4") || uRoleString.equals("5")) {

				bResponse = firmService.addUser(uNameString, uGenderString, uAgeString, uMailString, uPhoneString,
						uFirmString, uRoleString);
			} else {
				// 非法的角色
				bResponse.setResult(ResultCodeEnum.USER_ADD_FAILURE_INVALID_ROLE);
			}

		} else if (StrKit.isBlank(uNameString) || StrKit.isBlank(uGenderString) || StrKit.isBlank(uPhoneString)
				|| StrKit.isBlank(uMailString) || StrKit.isBlank(uRoleString) || StrKit.isBlank(uFirmString)
				|| StrKit.isBlank(uAgeString)) {
			// 请求参数有空
			bResponse.setResult(ResultCodeEnum.USER_ADD_FAILURE_PARA_NULL);
		} else {
			// 其它未知错误
			bResponse.setResult(ResultCodeEnum.UNKOWN_ERROE);
		}
		System.out.println(bResponse);
		renderJson(bResponse);

	}

	/**
	 * 查看某公司所有用户
	 */
	public void viewAllUserInfo() {

		BaseResponse bResponse = new BaseResponse();

		String fIdString = getPara("f_id");

		if (!StrKit.isBlank(fIdString)) {

			bResponse = firmService.viewAllUserInfo(fIdString);

		} else {
			// 请求参数为空
			bResponse.setResult(ResultCodeEnum.DB_WORNING_NULL);
		}

		renderJson(bResponse);

	}

	/**
	 * 更改用户角色
	 */
	public void modifyUserInfo() {

		BaseResponse bResponse = new BaseResponse();

		String uIdString = getPara("u_id");
		String uNameString = getPara("u_name");
		String uRoleString = getPara("u_role");
		String uGenderString = getPara("u_gender");
		String uPhoneString = getPara("u_phone");
		String uAgeString = getPara("u_age");
		String uMailString = getPara("u_mail");

		if (!StrKit.isBlank(uIdString) && !StrKit.isBlank(uNameString) && !StrKit.isBlank(uRoleString)
				&& !StrKit.isBlank(uGenderString) && !StrKit.isBlank(uPhoneString) && !StrKit.isBlank(uAgeString)
				&& !StrKit.isBlank(uMailString)) {

			// 角色只能为1或2或3或4
			if (uRoleString.equals("1") || uRoleString.equals("2") || uRoleString.equals("3")
					|| uRoleString.equals("4") || uRoleString.equals("5")) {
				// 进行修改
				bResponse = firmService.modifyUserInfo(uIdString, uNameString, uRoleString, uGenderString, uPhoneString,
						uAgeString, uMailString);
			} else {
				// 非法的角色名
				bResponse.setResult(ResultCodeEnum.USER_ADD_FAILURE_INVALID_ROLE);
			}

		} else if (StrKit.isBlank(uIdString) || StrKit.isBlank(uNameString) || StrKit.isBlank(uRoleString)
				|| StrKit.isBlank(uGenderString) || StrKit.isBlank(uPhoneString) || StrKit.isBlank(uAgeString)
				|| StrKit.isBlank(uMailString)) {
			// 请求参数有空
			bResponse.setResult(ResultCodeEnum.REQUEST_NO_PARAM_ID_ERROR);
		} else {
			// 未知的错误
			bResponse.setResult(ResultCodeEnum.UNKOWN_ERROE);
		}

		renderJson(bResponse);
	}

	/**
	 * 删除用户
	 */
	public void dropUser() {

		BaseResponse bResponse = new BaseResponse();

		String uIdString = getPara("u_id");
		if (!StrKit.isBlank(uIdString)) {
			// 删除用户
			bResponse = firmService.dropUser(uIdString);

		} else if (StrKit.isBlank(uIdString)) {
			// 请求ID为空
			bResponse.setResult(ResultCodeEnum.REQUEST_NO_PARAM_ID_ERROR);
		} else {
			// 未知的错误
			bResponse.setResult(ResultCodeEnum.UNKOWN_ERROE);
		}

		renderJson(bResponse);
	}

	/**
	 * 查看公司的所有知识
	 */
	public void viewAllKnowledgesByLabel() {

		BaseResponse bResponse = new BaseResponse();

		String fIdString = getPara("f_id");
		String orderString = getPara("order");
		String lIdString = getPara("l_id");

		if (!StrKit.isBlank(fIdString) && !StrKit.isBlank(orderString) && !StrKit.isBlank(lIdString)) {

			if (orderString.equals("k_click") || orderString.equals("k_collect") || orderString.equals("k_download")) {
				bResponse = firmService.viewAllKnowledgesByLabel(fIdString, orderString, lIdString);
			} else {
				bResponse.setResult(ResultCodeEnum.SORT_WAY_ERROR);
			}
		} else if (StrKit.isBlank(fIdString) || StrKit.isBlank(orderString) || StrKit.isBlank(lIdString)) {
			// 请求的参数有空
			bResponse.setResult(ResultCodeEnum.DB_WORNING_NULL);
		} else {
			// 未知的错误
			bResponse.setResult(ResultCodeEnum.UNKOWN_ERROE);
		}

		renderJson(bResponse);
	}

//	返回以某种方式排序的符合条件（不按类别，审核已经通过的）的所有知识
	public void searchKnowledges() {
		BaseResponse baseResponse = new BaseResponse();
		String search_msg = getPara("search_msg");
		String f_id = getPara("f_id");
		String order = getPara("order");
		baseResponse = firmService.searchKnowledges(search_msg, f_id, order);
		renderJson(baseResponse);
	}

//	返回以某种方式排序的符合条件（按类别，审核已经通过的）的所有知识
	public void searchKnowledgesByLabel() {
		BaseResponse baseResponse = new BaseResponse();
		String search_msg = getPara("search_msg");
		String f_id = getPara("f_id");
		String order = getPara("order");
		String l_id = getPara("l_id");
		baseResponse = firmService.searchKnowledgesByLabel(search_msg, f_id, order, l_id);
		renderJson(baseResponse);
	}
}
