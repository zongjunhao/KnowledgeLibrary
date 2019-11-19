<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<!-- 添加bootstrap的css样式表 -->
	<link rel="stylesheet" type="text/css" href="lib/css/bootstrap.css">
	<!-- 添加JQ -->
	<script type="text/javascript" src="lib/jq/jquery-3.4.1.js"></script>
	<script type="text/javascript" src="js/jquerySession.js"></script>
	<!-- 添加bootstrap的库 -->
	<script type="text/javascript" src="lib/js/bootstrap.js"></script>
	<!-- 	监听页面窗口大小改变的插件 -->
	<script type="text/javascript" src="lib/js/detect-element-resize.js"></script>
	<!-- 引用阿里的字体图标库 -->
	<link rel="stylesheet" type="text/css" href="http://at.alicdn.com/t/font_1333406_n153138zjo.css">
	<style>
		#userInfo{
			padding-top:20px;
		}
	</style>
</head>
<body>
	<div id="userInfo">
		<div class="container">
			<div class="row">
				<div class="col-md-6 col-md-offset-3">
					<form class="form-horizontal">
						<div class="form-group">
							<label class="col-sm-2 control-label">用户名</label>
							<div class="col-sm-10">
								<input type="text" class="form-control" placeholder="请输入用户名" />
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">密码</label>
							<div class="col-sm-10">
								<input type="text" class="form-control" placeholder="请输入密码" />
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">确认密码</label>
							<div class="col-sm-10">
								<input type="text" class="form-control" placeholder="请确认密码" />
							</div>
						</div>
					</form>
				</div>
			</div>
			
		</div>
	</div>

</body>
<script type="text/javascript">
  $(document).ready(function () {
		//监听子页面大小变化，设置父页面iframe的大小
		window.parent.document.getElementById("myiframe").height=$(document.body).height();
		console.log("setHeight")
		addResizeListener(document.getElementsByTagName("body")[0],function(){
			window.parent.document.getElementById("myiframe").height=$(document.body).height();
		});
	});


	</script>
</html>