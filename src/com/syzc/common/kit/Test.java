package com.syzc.common.kit;

import java.io.File;
import java.util.concurrent.ExecutionException;

public class Test {

	public static ElasticSearch esclient = new ElasticSearch(); 
	public static void main(String[] args) {
		// TODO Auto-generated method stub
//		File file = new File("C:\\Users\\zongjunhao\\Desktop\\Test\\upload.txt");
//		System.out.println(FileContent.getFileContent(file));
		esclient.update("1", "5", "", "", "1");
	}

}
