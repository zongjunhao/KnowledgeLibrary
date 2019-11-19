<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    <title>文件上传测试</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta content=”text/html;charset=utf-8″ />
	<script type="text/javascript" src = "js/jquery.js"></script>
    <script type="text/javascript" src = "js/jquerySession.js"></script>

 </head>
 
  	<body>
		<form action="user/uploadKnowledge" enctype="multipart/form-data" method="post" id="formId"> 
			文件名：<input  type="file" name="file"/>
			用户ID：<input type="text" name="u_id"/>
			公司ID：<input type="text" name="f_id"/>
			知识名称：<input type="text" name="k_name"/>
			知识类别：<input type="text" name="l_id"/>
			<input type="text" name="l_id"/>
			<input id="up" type="button" value="上传"/> 
			<button  id= down >下载</button>
		</form> 
		<iframe src="java规范.pdf" name="main" width=600px height=600px></iframe>
		
  	</body>
  	<script type="text/javascript">
  
    function toUpload(){
        $("input[type=checkbox]:checked:checked").each(function() {
            //由于复选框一般选中的是多个,所以可以循环输出 
             if ($(this).val() != ""&&$(this).val()!="on") {
                 window.open("${path }/test/download?id="+$(this).val(),"navTab");
             }
        });
    }
     
  	function download(name, href) {
        var a = document.createElement("a"), //创建a标签
        e = document.createEvent("MouseEvents"); //创建鼠标事件对象
        e.initEvent("click", false, false); //初始化事件对象
        a.href = href; //设置下载地址
        //alert(href);
        a.download = name; //设置下载文件名
        a.dispatchEvent(e); //给指定的元素，执行事件click事件 
    }
    
    </script>
</html>