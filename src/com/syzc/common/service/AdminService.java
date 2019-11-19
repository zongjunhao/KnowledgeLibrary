package com.syzc.common.service;

import java.util.ArrayList;
import java.util.List;

import com.jfinal.kit.StrKit;
import com.syzc.common.kit.BaseResponse;
import com.syzc.common.kit.ResultCodeEnum;
import com.syzc.common.kit.SendMail;
import com.syzc.common.model.Administrator;
import com.syzc.common.model.Firm;
import com.syzc.common.model.User;


public class AdminService {
	
	/**
	 * 系统管理员登录
	 * @param accountString
	 * @param passwordString
	 * @return bResponse
	 */
	public BaseResponse login(String accountString, String passwordString) {
		
		BaseResponse bResponse = new BaseResponse();
		
		
		if (StrKit.isBlank(accountString) || StrKit.isBlank(passwordString)) {
			
			bResponse.setResult(ResultCodeEnum.NO_ENOUGH_MES); // 登录失败，账号或密码为空
		} else {
			
			List<Administrator> list = Administrator.dao.find("select * from administrator where a_account = " + "'" + accountString + "'");
			
			if (list.size() == 1) {
				
				Administrator administrator = list.get(0);
				if (administrator.getAPwd().equals(passwordString)) {
					bResponse.setData(administrator);
					bResponse.setResult(ResultCodeEnum.LOGIN_SUCCESS); // 登录成功
				} else {
					bResponse.setResult(ResultCodeEnum.LOGIN_ERROR); // 登录失败，账号或密码错误
				}
			} else if (list.size() == 0) {
	
				bResponse.setResult(ResultCodeEnum.NO_EXIST_USER); // 登录失败，用户不存在
			} else {
				
				bResponse.setResult(ResultCodeEnum.UNKOWN_ERROE);
			}
		}
		
		return bResponse;
		
	}
	
	/**
	 * 系统管理员修改信息
	 * @param aIdString
	 * @param newPwdString
	 * @param newAccountString
	 * @return
	 */
	public BaseResponse modifyAdminInfo(String aIdString, String newPwdString, String newAccountString) {
		
		BaseResponse bResponse = new BaseResponse();
		
		if (StrKit.isBlank(newPwdString) || StrKit.isBlank(aIdString) || StrKit.isBlank(newAccountString)) {
			// 修改密码失败 请求参数有空
			bResponse.setResult(ResultCodeEnum.DB_WORNING_NULL); 
		} else if (!StrKit.isBlank(newPwdString) && !StrKit.isBlank(aIdString) && !StrKit.isBlank(newAccountString)) {
			
			List<Administrator> administrators = Administrator.dao.find("select * from administrator where a_id = " + "'" + aIdString + "'");
			
			if (administrators.size() == 1) {
				
				Administrator administrator = administrators.get(0);
				
				administrator.setAAccount(newAccountString);
				administrator.setAPwd(newPwdString);
				
				if (administrator.update()) {
					// 修改信息成功
					bResponse.setResult(ResultCodeEnum.INFO_UPDATE_SUCESS);
				} else {
					// 修改信息失败
					bResponse.setResult(ResultCodeEnum.INFO_UPDATE_FAILURE);
				}
			} else {
				// 系统故障，未知的错误
				bResponse.setResult(ResultCodeEnum.UNKOWN_ERROE);
			}
		} else {
			
			bResponse.setResult(ResultCodeEnum.UNKOWN_ERROE);
		}
		return bResponse;
	}
	
	/**
	 * 系统管理员据审核状态查找公司信息
	 * @param auditStateString
	 * @return bResponse
	 */
	public BaseResponse searchFirmsByAuditState(String auditStateString) {
		
		BaseResponse bResponse = new BaseResponse();
		
		if (StrKit.isBlank(auditStateString)) {
			
			bResponse.setResult(ResultCodeEnum.DB_WORNING_NULL); // 查找失败，请求的参数错诶
		} else if (!StrKit.isBlank(auditStateString)) {
			
			List<Firm> firms = Firm.dao.find("select * from firm where f_state = " + "'" + auditStateString + "'");
			
			if (firms.size() == 0) {
				
				bResponse.setResult(ResultCodeEnum.DB_FIND_FAILURE); // 查找失败，没有记录
			} else if (firms.size() >= 1) {
				
				bResponse.setData(firms);
				bResponse.setResult(ResultCodeEnum.DB_FIND_SUCCESS); // 查找成功
			} else {
				
				bResponse.setResult(ResultCodeEnum.UNKOWN_ERROE); // 查找失败，未知的错误
			}
		}
		
		return bResponse;
	}
	
	/**
	 * 系统管理员更改公司的审核状态
	 * @param fIdString
	 * @param newAuditStateString
	 * @return bResponse
	 */
	public BaseResponse modfiyAuditState(String fIdString, String newAuditStateString) {
		
		BaseResponse bResponse = new BaseResponse();
		
		if (StrKit.isBlank(fIdString) || StrKit.isBlank(newAuditStateString)) {
			
			bResponse.setResult(ResultCodeEnum.DB_WORNING_NULL); // 更改失败，请求的参数错误
		} else if (!StrKit.isBlank(fIdString) && !StrKit.isBlank(newAuditStateString)) {
			
			Firm firm = Firm.dao.findById(fIdString);
			firm.setFState(Integer.parseInt(newAuditStateString));
			
			if (firm.update()) {
				
				bResponse.setResult(ResultCodeEnum.STATE_CHANGE_SUCESS); // 更改成功
				noticeApplyIsPass(fIdString, newAuditStateString);
			} else {
				
				bResponse.setResult(ResultCodeEnum.STATE_CHANGE_FAILURE_UPDATE_DB_ERROE); // 更改失败
			}
		} else {
			
			bResponse.setResult(ResultCodeEnum.UNKOWN_ERROE);
		}
		
		return bResponse;
	}
	
	/**
	 * 查看公司详细信息
	 * @param fIdString
	 * @return bResponse
	 */
	public BaseResponse viewFirmInfo(String fIdString) {
		
		BaseResponse bResponse = new BaseResponse();
		
		if (!StrKit.isBlank(fIdString)) {
			
			List<Firm> firms = Firm.dao.find("select * from firm where f_id = " + "'" + fIdString + "'");
			
			if (firms.size() == 1) {
				
				Firm firm = firms.get(0);
				bResponse.setData(firm);
				bResponse.setResult(ResultCodeEnum.DB_FIND_SUCCESS); // 公司信息查找成功
			} else if (firms.size() == 0) {
				
				bResponse.setResult(ResultCodeEnum.DB_FIND_FAILURE); // 没有该条记录
			} else {
				
				bResponse.setResult(ResultCodeEnum.UNKOWN_ERROE); // 系统故障
			}
		} else if (StrKit.isBlank(fIdString)) {
			
			bResponse.setResult(ResultCodeEnum.DB_WORNING_NULL); // 请求参数为空
		} else {
			
			bResponse.setResult(ResultCodeEnum.UNKOWN_ERROE); // 未知的错误。系统故障
		}
		
		return bResponse;
	}
	
	/**
	 * 向公司发送注册成功与否的信息
	 * @param fIdString
	 * @param auditStateString
	 * @return
	 */
	public BaseResponse noticeApplyIsPass(String fIdString, String auditStateString) {
		
		BaseResponse bResponse = new BaseResponse();
		SendMail sendMail = new SendMail();
		
		if (!StrKit.isBlank(fIdString) && !StrKit.isBlank(auditStateString)) {
			
			List<Firm> firms = Firm.dao.find("select * from firm where f_id = " + "'" + fIdString + "'");
			if (firms.size() == 1) {
				
				Firm firm = firms.get(0);
				String nameString = firm.getFCorporation();
//				String emailString = firm.getFMail();
				String emailString = null;
				List<User> users = User.dao.find("select * from user where u_firm = " + "'" + fIdString + "'" + " and u_role = 5 ");
				if (users.size() == 1) {
					User user = users.get(0);
					emailString = user.getUEmail();
					
				}
				String noticeMsgString = null;
				
				if (auditStateString.equals("2")) {
					
					noticeMsgString = "您好，贵公司的企业账号注册申请已通过，欢迎使用！";
				} else if (auditStateString.equals("3")) {
					
					noticeMsgString = "抱歉，贵公司的企业账号注册申请并未通过，请重新提交注册申请！";
				}
				
				boolean sendState = sendMail.sendingMail(nameString, emailString, noticeMsgString);
				if (sendState) {
					// 邮件发送成功
					bResponse.setResult(ResultCodeEnum.NOTICE_SEND_SUCCESS);
				} else {
					// 邮件发送失败，邮件系统故障
					bResponse.setResult(ResultCodeEnum.NOTCE_SEND_FAILURE_MAILSYS_ERROR);
				}
				
			} else if (firms.size() == 0) {
				// 邮件发送失败，公司账户不存在
				bResponse.setResult(ResultCodeEnum.NOTCE_SEND_FAILURE_FIRM_NOTEXIST);
			} else {
				// 未知的故障，系统错误
				bResponse.setResult(ResultCodeEnum.UNKOWN_ERROE);
			}
		} else if (StrKit.isBlank(fIdString) || StrKit.isBlank(auditStateString)) {
			// 请求的参数有空
			bResponse.setResult(ResultCodeEnum.DB_WORNING_NULL);
		} else {
			// 未知的故障
			bResponse.setResult(ResultCodeEnum.UNKOWN_ERROE);
		}
		
		return bResponse;	
	}
	
	/**
	 * 向所有公司发送通知
	 * @param noticeMsgString
	 * @return
	 */

	public BaseResponse noticeAll(String noticeMsgString) {
		
		BaseResponse bResponse = new BaseResponse();
		SendMail sendMail = new SendMail();
		
		if (!StrKit.isBlank(noticeMsgString)) {
			
			List<Firm> firms = Firm.dao.find("select * from firm where f_state = 2");
			List<Firm> failNoticeFirms = new ArrayList<Firm>();
			
			boolean sendFlag = true;
			
			if (firms.size() > 0) {
				
				boolean sendState = false;
				for (int i = 0; i < firms.size(); i++) {
					
					Firm firm = firms.get(i);
					String nameString = firm.getFCorporation();
					int fId = firm.getFId();
										
					String emailString = null;
					List<User> users = User.dao.find("select * from user where u_firm = " + "'" + fId + "'" + " and u_role = 5 ");
					if (users.size() == 1) {
						User user = users.get(0);
						emailString = user.getUEmail();
						
					}
					sendState = sendMail.sendingMail(nameString, emailString, noticeMsgString);
					
					if (!sendState) {
						
						sendFlag = false;
						failNoticeFirms.add(firm); // 将未成功发送通知的公司添加
					}
				}
				
				if (sendFlag) {
					// 邮件发送成功
					bResponse.setResult(ResultCodeEnum.NOTICE_SEND_SUCCESS);
				} else {
					// 未成功通知公司信息
					bResponse.setData(failNoticeFirms);
					// 邮件发送未完全成功，部分未成功通知
					bResponse.setResult(ResultCodeEnum.NOTCE_SEND_FAILURE_MAILSYS_ERROR);
				}
				
			} else if (firms.size() == 0) {
				// 邮件发送失败，公司账户不存在
				bResponse.setResult(ResultCodeEnum.NOTCE_SEND_FAILURE_FIRM_NOTEXIST);
			} else {
				// 未知的故障，系统错误
				bResponse.setResult(ResultCodeEnum.UNKOWN_ERROE);
			}
		} else if (StrKit.isBlank(noticeMsgString)) {
			// 请求的参数有空
			bResponse.setResult(ResultCodeEnum.DB_WORNING_NULL);
		} else {
			// 未知的故障
			bResponse.setResult(ResultCodeEnum.UNKOWN_ERROE);
		}
		
		return bResponse;	
	}
	
	public BaseResponse searchFirmsByName(String queryMsgString) {
		
		BaseResponse bResponse = new BaseResponse();
		
		List<Firm> firms = Firm.dao.find("select * from firm where f_state = 2 and f_name like '%" + queryMsgString + "%'");
		
		if (firms.size() > 0) {
			// 查询成功
			bResponse.setData(firms);
			bResponse.setResult(ResultCodeEnum.DB_FIND_SUCCESS);
		} else if (firms.size() == 0) {
			// 查询结果为空
			bResponse.setResult(ResultCodeEnum.DB_FIND_FAILURE);
		} else {
			// 数据库系统错误
			bResponse.setResult(ResultCodeEnum.DB_SYS_ERROR);
		}
		
		return bResponse;
	}
}
