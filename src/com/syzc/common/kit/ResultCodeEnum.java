package com.syzc.common.kit;


public enum ResultCodeEnum
{
	
	SITES_OPEN("1001","网页打开成功"),
	INTERNTE_FAILURE("1002","网络错误，请重试"),
	UNKOWN_ERROE("1003","未知的错误"),
	REQUEST_NO_PARAM_ID_ERROR("1004","页面请求参数错误"),
	DB_SYS_ERROR("1005","数据库错误"),
	RECORD_NO_EXIST("1006","记录不存在"),
	
	ACCOUNT_LOGGED_IN("1007","账号已经登录"),
	

	DB_CONNECTION_SUCCESS("2000","数据库连接成功"),
	DB_CONNECTION_FAILURE("2001","数据库连接失败"),
	DB_UPDATE_SUCCESS("2002","数据库修改成功"),
	DB_UPDATE_ERROR("2003","数据库修改失败"),
	DB_ERROR_OVERFLOW("2004","数据库修改失败_字段字数超过规定"),
	DB_ERROR_FORMAT("2005","数据库修改失败_字段输入数据格式错误"),

	//
	DB_FIND_SUCCESS("2006","数据库查找成功"),
	DB_FIND_FAILURE("2007","数据库查找失败，没有该条记录"),
	//

	DB_WORNING_NULL_WRONGPARA("2008","该次查询结果为空_输入参数错误"),
	DB_DELETE_SUCCESS("2009","数据删除成功"),
	DB_DELETE_FAILURE("2010","数据删除失败"),
	DB_WORNING_NULL("2011","请求参数为空"),

	//
	USER_ADD_SUCCESS("2012","添加用户成功"),
	USER_ADD_FAILURE_MAIL_EXISTED("2013","添加用户失败，该邮箱已经存在"),
	USER_ADD_FAILURE("2014","添加用户失败"),
	USER_ADD_FAILURE_PARA_NULL("2015","请求参数有空"),
	USER_ADD_FAILURE_INVALID_ROLE("2016","非法的角色"),
	//

	

	//
	COMMENT_ADD_SUCCESS("2017","评论添加成功"),
	COMMENT_ADD_FAILURE("2018","评论添加失败"),
	//

	//
	KNOWLEDGE_DOWNLOAD_SUCCESS("2019","知识下载成功"),
	KNOWLEDGE_DOWNLOAD_FAILURE("2020","知识下载失败"),
	//
	KNOWLEDGE_DELETE_SUCCESS("2021","知识删除成功"),
	KNOWLEDGE_DELETE_FAILURE_DB_ERROR("2022","知识删除失败_数据库删除失败"),
	KNOWLEDGE_DELETE_FAILURE_FILE_ERROR("2032","知识删除失败_文件删除失败"),
	KNOWLEDGE_DELETE_FAILURE_NOT_EXIST("2033","知识删除失败_不存在"),
	//
	KNOWLEDGE_UPLOAD_SUCCESS("2023","知识上传成功"),
	KNOWLEDGE_UPLOAD_FAILURE("2024","知识上传失败"),
	//
	
	COLLECTION_ADD_SUCCESS("2025","收藏成功"),
	COLLECTION_ADD_FAILURE("2026","收藏失败"),
	COLLECTION_EXISTED("2031","收藏失败，您已收藏了本条知识"),
	
	LABEL_ADD_SUCCESS("2032","添加标签成功"),
	LABEL_ADD_FAILURE_ALREADY_EXIST("2033","添加标签失败_标签已经存在"),
	LABEL_ADD_FAILURE_FIRM_NOT_EXIST("2034","添加标签失败_公司不存在"),
	
	LABEL_DELETE_SUCCESS("2035","删除标签成功"),
	LABEL_DELETE_FAILURE_NOT_EXIST("2036","删除标签失败_标签不存在"),
	
	LABEL_UPDATE_FAILURE_NOT_EXIST("2037","修改标签失败_标签不存在"),
	LABEL_UPDATE_FAILURE_ALREADY_EXIST("2038","修改标签失败_标签名已经存在"),
	LABEL_UPDATE_SUCCESS("2039","修改标签成功"),
	
	//
	USER_DELETE_SUCCESS("2027","用户删除成功"),
	USER_DELETE_FAILURE_DB_ERROR("2028","用户删除失败，数据库错误"),
	USER_DELETE_FAILURE_USER_NOT_EXIST("2029","用户删除失败，用户不存在"),
	//
	SORT_WAY_ERROR("2030","错误的排序方式"),

	PARA_FORMAT_ERROR("3000","请求的参数格式错误"),
	PARA_NUM_ERROR("3001","请求的参数个数错误"),
	PARA_PHONENUM_ERROR("3002","错误的手机号"),
	PARA_EMAIL_ERROR("3003","错误的邮箱格式"),
	PARA_PASSWORD_ERROR("3004","错误的密码格式"),


	//
	LOGIN_SUCCESS("4000","登录成功"),
	LOGIN_ERROR("4001","登录失败_账号或密码错误"),
	NO_EXIST_USER("4002","登录失败_用户不存在"),
	//

	NO_ENOUGH_MES("4003","登录失败_账号或密码为空"),
	
	LOGOUT_SUCCESS("4004","退出登录成功"),
	NO_LOGIN_USER("4005","退出登录失败_用户未登录"),
	
	LOGIN_FAILURE_AUDIT_NOT_PASS("4006","登录失败_账号审核不通过"),
	LOGIN_FAILURE_NO_AUDIT("4007","登录失败_账号未进行审核"),
	LOGIN_FAILURE_CODE_ERROR("4008", "登陆失败，验证码错误"),

	//
	INFO_UPDATE_SUCESS("5000","信息修改成功"),
	INFO_UPDATE_FAILURE("5001","信息修改失败"),
	UPDATE_FAILURE_MAIL_EXISTED("5002","信息修改失败，该邮箱已存在"),
	UPDATE_FAILURE_NO_ENOUGH_MES("5003","信息修改失败，请求参数不足"),
	UPDATE_FAILURE_MAIL_NAME_EXIST("5004","信息修改失败，企业名或邮箱已经被占用"),
	UPDATE_FAILURE_FIRM_NOT_EXIST("5005","信息修改失败，企业不存在"),
	UPDATE_FAILURE_PASSWORD_DIFFERENT("5006","修改失败_两次密码不一致"),
	//
	
	//
	ROLE_UPDATE_SUCCESS("5007","权限修改成功"),
	ROLE_UPDATE_FAILURE("5008","权限修改失败_数据库错误"),
	ROLE_UPDATE_FAILURE_NO_USER("5009","权限修改失败_用户不存在"),
	
	INVALUD_LABEL("5010","非法的标签"),
	//
	STATE_CHANGE_SUCESS("6000","状态修改成功"),
	STATE_CHANGE_FAILURE_UPDATE_DB_ERROE("6001","状态修改失败_更新数据库错误"),
	STATE_CHANGE_FAILURE_INVALID_AUDIT_STATE("6002","状态修改失败_非有效的审核状态"),
	


	//
	NOTICE_SEND_SUCCESS("7000","通知发送成功"),
	NOTCE_SEND_FAILURE_MAILSYS_ERROR("7001","通知发送失败（部分公司未成功通知）"),
	NOTCE_SEND_FAILURE_FIRM_NOTEXIST("7002","通知发送失败_公司不存在"),
	//
	CONFIRMCODE_SEND_SUCCESS("7003","验证码发送成功"),
	CONFIRMCODE_SEND_FAILURE("7004","验证码发送失败"),
	
	
	//
	REGISTER_SUCCESS("8000", "注册成功"),
	REGISTER_FAILURE_USER_MAIL_EXIST("8001","注册失败，用户邮箱已经存在"),
	REGISTER_FAILURE_NAME_EXIST("8002","注册失败，企业名已被注册"),
	REGISTER_FAILURE_PASSWORD_DIFFERENT("8003","注册失败，两次密码不一致"),
	REGISTER_FAILURE_NO_ENOUGH_MES("8004","注册失败，请求参数不足"),
	REGISTER_FAILURE_CONFIRMCODE_ERROR("8005","注册失败，验证码错误"),
	REGISTER_FAILURE_SYSTEM_ERROR("8006","注册失败，系统错误");
	//
	
	private String code;
    private String desc;

    ResultCodeEnum(String code, String desc)
    {
        this.code = code;
        this.desc = desc;
    }

    public String getCode()
    {
        return code;
    }

    public String getDesc()
    {
        return desc;
    }


}
