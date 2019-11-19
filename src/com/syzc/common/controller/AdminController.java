package com.syzc.common.controller;

import com.jfinal.core.Controller;
import com.jfinal.kit.StrKit;
import com.syzc.common.kit.BaseResponse;
import com.syzc.common.kit.ResultCodeEnum;
import com.syzc.common.service.AdminService;

public class AdminController extends Controller {

	public static AdminService adminService = new AdminService();
//	BaseResponse bResponse = new BaseResponse();

//	public void index() {
//		
//	}

//	验证码图片
	public void pic() {
		renderCaptcha();
	}

	public void login() {

		BaseResponse bResponse = new BaseResponse();

		boolean result = validateCaptcha("inputRandomCode");
		if (result) {
			System.out.println("验证码正确");
			String accountString = getPara("a_account");
			String passwordString = getPara("a_pwd");

			if (!StrKit.isBlank(accountString) && !StrKit.isBlank(passwordString)) {
//				if (getSessionAttr(accountString) != null && getSessionAttr(accountString).equals("ready")) {
//					// 账号已经登录
//					bResponse.setResult(ResultCodeEnum.LOGIN_SUCCESS);
//				} else {
					
					bResponse = adminService.login(accountString, passwordString);
//				}
				if (bResponse.getResultCode().equals("4000")) {

					setSessionAttr(accountString, "ready");
				} else {

					setSessionAttr(accountString, "unready");
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

	public void logout() {

		BaseResponse bResponse = new BaseResponse();

		String aAccountString = getPara("a_account");

		if (getSessionAttr(aAccountString) != null && getSessionAttr(aAccountString).equals("ready")) {

			removeSessionAttr(aAccountString);
			System.out.println("用户" + aAccountString + "退出登录成功");
			bResponse.setResult(ResultCodeEnum.LOGOUT_SUCCESS);
		} else {

			System.out.println("该用户未登录");
			bResponse.setResult(ResultCodeEnum.NO_LOGIN_USER);
		}

		renderJson(bResponse);
	}

	public void modifyAdminInfo() {

		BaseResponse bResponse = new BaseResponse();

		String aIdString = getPara("a_id");
		String newAccountString = getPara("newAccount");
		String newPwdString = getPara("newPwd");

		if (!StrKit.isBlank(aIdString) && !StrKit.isBlank(newPwdString) && !StrKit.isBlank(newAccountString)) {

			bResponse = adminService.modifyAdminInfo(aIdString, newPwdString, newAccountString);

		} else {

			bResponse.setResult(ResultCodeEnum.DB_WORNING_NULL);
		}

		renderJson(bResponse);
	}

	public void searchFirmsByAuditState() {

		BaseResponse bResponse = new BaseResponse();

		String auditStateString = getPara("audit_state");

		if (!StrKit.isBlank(auditStateString)) {

			bResponse = adminService.searchFirmsByAuditState(auditStateString);
		} else {

			bResponse.setResult(ResultCodeEnum.DB_WORNING_NULL);
		}

		renderJson(bResponse);
	}

	public void modifyAuditState() {

		BaseResponse bResponse = new BaseResponse();

		String fIdString = getPara("f_id");
		String newAuditStateString = getPara("newAuditState");

		if (!StrKit.isBlank(fIdString) && !StrKit.isBlank(newAuditStateString)) {

			if (newAuditStateString.equals("1") || newAuditStateString.equals("2") || newAuditStateString.equals("3")) {
				// 审核状态只能为1或2或3
				bResponse = adminService.modfiyAuditState(fIdString, newAuditStateString);
			} else {
				// 非有效的审核状态
				bResponse.setResult(ResultCodeEnum.STATE_CHANGE_FAILURE_INVALID_AUDIT_STATE);
			}

		} else {

			bResponse.setResult(ResultCodeEnum.DB_WORNING_NULL); // 更改失败，请求的参数错误
		}

		renderJson(bResponse);
	}

	public void noticeApplyIsPass() {

		BaseResponse bResponse = new BaseResponse();

		String fIdString = getPara("f_id");
		String auditStateString = getPara("auditState");

		if (!StrKit.isBlank(fIdString) && !StrKit.isBlank(auditStateString)) {

			bResponse = adminService.noticeApplyIsPass(fIdString, auditStateString);
		} else {

			bResponse.setResult(ResultCodeEnum.DB_WORNING_NULL); // 请求参数为空
		}

		renderJson(bResponse);
	}

	public void noticeAll() {

		BaseResponse bResponse = new BaseResponse();
		String noticeMsgString = getPara("noticeMsg");

		if (!StrKit.isBlank(noticeMsgString)) {

			bResponse = adminService.noticeAll(noticeMsgString);
		} else {

			bResponse.setResult(ResultCodeEnum.DB_WORNING_NULL); // 请求参数为空
		}

		renderJson(bResponse);
	}

	public void viewFirmInfo() {

		BaseResponse bResponse = new BaseResponse();
		String fIdString = getPara("f_id");

		if (!StrKit.isBlank(fIdString)) {

			bResponse = adminService.viewFirmInfo(fIdString);
		} else if (StrKit.isBlank(fIdString)) {

			bResponse.setResult(ResultCodeEnum.DB_WORNING_NULL); // 请求参数错误
		} else {

			bResponse.setResult(ResultCodeEnum.UNKOWN_ERROE); // 未知的错误
		}

		renderJson(bResponse);
	}

	public void searchFirmsByName() {

		BaseResponse bResponse = new BaseResponse();
		String queryMsgString = getPara("queryMsg");

		if (!StrKit.isBlank(queryMsgString)) {

			bResponse = adminService.searchFirmsByName(queryMsgString);
		} else if (StrKit.isBlank(queryMsgString)) {

			bResponse.setResult(ResultCodeEnum.DB_WORNING_NULL); // 请求参数错误
		} else {

			bResponse.setResult(ResultCodeEnum.UNKOWN_ERROE); // 未知的错误
		}

		renderJson(bResponse);
	}
}
