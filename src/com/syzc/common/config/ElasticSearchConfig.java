package com.syzc.common.config;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.concurrent.ExecutionException;

import org.elasticsearch.action.get.GetResponse;
import org.elasticsearch.client.transport.TransportClient;
import org.elasticsearch.common.settings.Settings;
import org.elasticsearch.common.transport.InetSocketTransportAddress;
import org.elasticsearch.transport.client.PreBuiltTransportClient;

import com.syzc.common.kit.ElasticSearch;

public class ElasticSearchConfig {

//	public static void main(String[] args) throws UnknownHostException {
//		TransportClient client = new PreBuiltTransportClient(Settings.EMPTY)
//				.addTransportAddress(new InetSocketTransportAddress(InetAddress.getByName("127.0.0.1"), 9300));
//		GetResponse response = client.prepareGet("encommerce", "product", "1").get();
//		System.out.println(response.getSourceAsString());
//		client.close();
//	}
//	
//	public TransportClient client() throws UnknownHostException {
//		TransportClient client = new PreBuiltTransportClient(Settings.EMPTY)
//				.addTransportAddress(new InetSocketTransportAddress(InetAddress.getByName("127.0.0.1"),9300));
//		return client;
//	}
	
	public static ElasticSearch esclient = new ElasticSearch(); 
	
	public static void main(String[] args) {
//		esclient.put("1", "1", "国歌", "中华人民共和国", "1");
//		esclient.put("1", "2", "中华", "中华人民共和国国歌", "1");
//		esclient.put("1", "3", "共和国", "国歌", "1");
//		esclient.put("1", "4", "人民", "中华", "1");
//		esclient.put("1", "5", "国歌", "共和国国歌", "1");
//		esclient.put("2", "3", "知识", "中华人民共和国国歌", "1");
//		esclient.get("knowledge", "1", "1");
		esclient.search("1", "国歌");
//		esclient.delete("knowledge", "1", "1");
//		esclient.delete("knowledge", "1", "2");
//		esclient.delete("knowledge", "1", "3");
//		esclient.delete("knowledge", "1", "4");
//		esclient.delete("knowledge", "1", "5");
//		esclient.update("1", "5", "", "", "2");
	}

}
