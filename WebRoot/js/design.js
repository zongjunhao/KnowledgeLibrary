function check(){
	var name=$("#name").val();
	if (username == '' || username == undefined || username == null){
	    alert("请输入姓名");
	    $("#name").css('borderColor','red'); //添加css样式
	}else {
	    $("#name").css('borderColor',''); //取消css样式
	}
}
