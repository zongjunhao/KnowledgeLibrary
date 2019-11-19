package com.syzc.common.controller;

import com.jfinal.core.Controller;
import com.syzc.common.service.IndexService;

public class IndexController extends Controller{
	public static IndexService indexService = new IndexService();
	
	public void index() {
		render("/login.html");
	}
}
  