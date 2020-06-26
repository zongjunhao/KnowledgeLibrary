package com.syzc.common.kit;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutionException;

import org.elasticsearch.action.delete.DeleteResponse;
import org.elasticsearch.common.text.Text;
import org.elasticsearch.action.get.GetResponse;
import org.elasticsearch.action.index.IndexResponse;
import org.elasticsearch.action.search.SearchRequestBuilder;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.action.update.UpdateRequest;
import org.elasticsearch.action.update.UpdateResponse;
import org.elasticsearch.client.transport.TransportClient;
import org.elasticsearch.common.settings.Settings;
import org.elasticsearch.common.transport.InetSocketTransportAddress;
import org.elasticsearch.common.xcontent.XContentFactory;
import org.elasticsearch.index.query.BoolQueryBuilder;
import org.elasticsearch.index.query.QueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.rest.RestStatus;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.SearchHits;
import org.elasticsearch.search.fetch.subphase.highlight.HighlightBuilder;
import org.elasticsearch.search.fetch.subphase.highlight.HighlightField;
import org.elasticsearch.transport.client.PreBuiltTransportClient;

public class ElasticSearch {

	TransportClient client;

	public ElasticSearch() {
		try {
			TransportClient client = new PreBuiltTransportClient(Settings.EMPTY)
					.addTransportAddress(new InetSocketTransportAddress(InetAddress.getByName("127.0.0.1"), 9300));
			this.client = client;
		} catch (UnknownHostException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public void get(String index, String type, String id) {
		GetResponse response = client.prepareGet(index, type, id).get();
		System.out.println(response.getSourceAsString());
	}

	public void put(String f_id, String k_id, String k_name, String k_text, String k_state) {

		Map<String, Object> json = new HashMap<String, Object>();
		json.put("k_id", k_id);
		json.put("k_name", k_name);
		json.put("k_text", k_text);
		json.put("k_state", k_state);
		IndexResponse response = client.prepareIndex("knowledge", f_id, k_id).setSource(json).get();

		String _index = response.getIndex();
		System.out.println("_index:" + _index);
		// Type name
		String _type = response.getType();
		System.out.println("_type:" + _type);
		// Document ID (generated or not)
		String _id = response.getId();
		System.out.println("_id:" + _id);
		// Version (if it's the first time you index this document, you will get: 1)
		long _version = response.getVersion();
		System.out.println("_version:" + _version);
		// status has stored current instance statement.
		RestStatus status = response.status();
		System.out.println("status:" + status);

	}

	public void delete(String index, String type, String id) {

		DeleteResponse response = client.prepareDelete(index, type, id).get();

		String _index = response.getIndex();
		System.out.println("_index:" + _index);
		// Type name
		String _type = response.getType();
		System.out.println("_type:" + _type);
		// Document ID (generated or not)
		String _id = response.getId();
		System.out.println("_id:" + _id);
		// Version (if it's the first time you index this document, you will get: 1)
		long _version = response.getVersion();
		System.out.println("_version:" + _version);
		// status has stored current instance statement.
		RestStatus status = response.status();
		System.out.println("status:" + status);
	}

	public void update(String f_id, String k_id, String k_name, String k_text, String k_state) {

		Map<String, Object> json = new HashMap<String, Object>();
		if (k_id != "")
			json.put("k_id", k_id);
		if (k_name != "")
			json.put("k_name", k_name);
		if (k_text != "")
			json.put("k_text", k_text);
		if (k_state != "")
			json.put("k_state", k_state);

		// 创建修改请求
		UpdateRequest updateRequest = new UpdateRequest();
		updateRequest.index("knowledge");
		updateRequest.type(f_id);
		updateRequest.id(k_id);
		updateRequest.doc(json);

		try {
			UpdateResponse response = client.update(updateRequest).get();
		} catch (InterruptedException | ExecutionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("更新索引成功");

	}

	public List<Map<String, Object>> search(String f_id, String searchMsg) {

		// 查询配置
		QueryBuilder multiMatchQueryBuilder = QueryBuilders.multiMatchQuery(searchMsg) // 设置查询信息
				.field("k_name", 2).field("k_text", 1) // 设置所查询的每个域的权重
				.analyzer("ik_max_word"); // 设置查询时使用的分词器为ik分词
		BoolQueryBuilder builder = QueryBuilders.boolQuery();
		builder.must(multiMatchQueryBuilder);
		builder.must(QueryBuilders.matchQuery("k_state", "2"));

		// 设置高亮条件
		HighlightBuilder highlightBuilder = new HighlightBuilder(); // 高亮查询生成器
		highlightBuilder.field("k_name"); // 高亮查询字段
		highlightBuilder.field("k_text"); // 高亮查询字段
		highlightBuilder.requireFieldMatch(false); // 多字段高亮时设置为false
		highlightBuilder.preTags("<span style=\"color:red\">"); // 高亮结果设置
		highlightBuilder.postTags("</span>");

		// 查询
		SearchResponse response = client.prepareSearch("knowledge").setTypes(f_id).setQuery(builder)
				.highlighter(highlightBuilder).get();

		List<Map<String, Object>> course = new ArrayList<>();
		if (response.status() != RestStatus.OK) {
			return course;
		}
		// 获取查询结果
		for (SearchHit hit : response.getHits()) {
			System.out.println(hit.getSourceAsString());
			System.out.println(hit.getScore()); // 查询匹配的分数
			System.out.println(hit.getType());
			// 获取高亮字段
			Map<String, HighlightField> highlightFields = hit.getHighlightFields();
			HighlightField nameField = highlightFields.get("k_name");
			HighlightField textField = highlightFields.get("k_text");
			Map<String, Object> source = hit.getSource();
			// 判断是否为空，否则某一个域中没有匹配结果会报空指针异常，下同
			if (nameField != null) {
				Text[] fragments = nameField.fragments();
				String name = "";
				for (Text text : fragments) { // 循环将高亮结果组合
					name += text;
				}
				source.put("k_name", name); // 使用高亮的结果替换掉原文本的内容
			}
			if (textField != null) {
				Text[] fragments = textField.fragments();
				String textContent = "";
				for (Text text : fragments) {
					textContent += text;
				}
				source.put("k_text", textContent);
			}
			System.out.println(source);
			System.out.println();
			course.add(source); // 将修改后的此条结果添加到返回结果中
		}
		System.out.println(course);

//		SearchHits hits = response.getHits();
//		if(hits == null) {
//			System.out.println("无匹配结果");
//		}
//		
//		for(SearchHit hit : hits) {
//			System.out.println(hit.getSourceAsString());
//			System.out.println(hit.getScore());
//			System.out.println(hit.getType());
//			Text[] fragments = hit.getHighlightFields().get("k_text").fragments();
//			String nameTmp ="";
//            for(Text text:fragments){
//                nameTmp+=text;
//            }
//			System.out.println(nameTmp);
//			Map<String, Object> map = hit.getSource();
//			for(String key : map.keySet()) {
//				System.out.println(key + "=" + map.get(key));
//			}
//		}
		return course;
	}
}
