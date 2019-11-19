<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>通知信息</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta content=”text/html;charset=utf-8″ />
	<link rel="stylesheet" type="text/css" href="css/design.css">
	<script type="text/javascript" src = "js/jquery.js"></script>
  	<script type="text/javascript" src = "js/jquerySession.js"></script>
  	<!-- 	监听页面窗口大小改变的插件 -->
	<script type="text/javascript" src="lib/js/detect-element-resize.js"></script>
	
	<style>
	  .row{
        display:block;
        width:600px;
        margin:1em auto;
      }
      button{
    float:right;
    padding: 4px;
    width: 70px;
    font-size: 1em;
    border: 1px solid  #ccc;
    height: 40px;
    background-color:white;
    font-family:Microsoft YaHei;
  	border-radius: 5px;
  	margin-left:1em;
  }
  button:focus{
    border:none;
    box-shadow: inset 0 1px 1px rgba(0,0,0,.075),0 0 8px rgba(102,175,233,.6);
  }
  .loading{
		position:absolute;
		width:400px;
		height:300px;
		top:90px;
		left:30%;
		z-index:100;
		
	}
	</style>

  </head>
  <body>
    <center>
    <div class="flex_column">
    	<div class="com_list_title">
			系统通知信息
		</div>
		<div id="loading"></div>
		<div>
			<textarea class="notify" name="notify" id="notify" placeholder="在此输入通知信息..." size="25" ></textarea>
			<div id="test1" style="color:red;">通知消息不能为空!</div>
		</div>
		<div class="row">
		    <button id="send">发送</button>
		</div>
		
		
    </div>
 
  </center>
	<script type="text/javascript">
	  $("#test1").hide();
	  $("#send").click(function(){
		  if(($('#notify').val()=='')){
		        $("#test1").show();
		      }else{
		        $("#test1").hide();
		      }
	  })
	  
	 $("#send").click(function(){
		 
		 if(($('#notify').val()=='')){
		        $("#test1").show();
		      }else{
		    	  $("#loading").append("<img src='./image/加载动画.gif' class='loading'></img>");
		 $.ajax({
				type : "POST",
				url : "/KnowledgeLibrary/sysAdmin/noticeAll",
				data : {
					noticeMsg : $("#notify").val()
				},
				success : function(json) {
					if (json.resultCode == "7000") {
						//发送成功
						//alert(json.resultDesc);
						$("#loading").remove()
						$("#test1").text(json.resultDesc)
						window.location.href = "admin_notify.jsp";
					} else {
						//发送失败
						//alert(json.resultDesc);
						$("#loading").remove()
						$("#test1").show()
						$("#test1").text(json.resultDesc)
					}
				},
				error : function(jqXHR) {
					$("#loading").remove()
					$("#test1").text("您所请求的页面有异常")
				}
			});
		      }
	 }) 
	 
	 $(document).ready(function () {
		//监听子页面大小变化，设置父页面iframe的大小
		 if($(document.body).height()<355){
				window.parent.document.getElementById("myiframe").height = 355
			}else{
				window.parent.document.getElementById("myiframe").height=$(document.body).height();
			}
			//window.parent.document.getElementById("myiframe").height=$(document.body).height();
			console.log("setHeight")
			addResizeListener(document.getElementsByTagName("body")[0],function(){
				if($(document.body).height()<355){
					window.parent.document.getElementById("myiframe").height = 355
				}else{
					window.parent.document.getElementById("myiframe").height=$(document.body).height();
				}
			});
	});
	</script> 
  </body>
</html>