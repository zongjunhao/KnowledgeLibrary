package com.syzc.common.kit;

import com.syzc.common.model.Knowledge;

public class KnowledgeDetails {
	
	private Knowledge knowledge;
	private Object comment;
	private Object labels;
	private String authorName;
	private int isCollect;
	
	public Knowledge getKnowledge() {
		return knowledge;
	}
	
	public void setKnowledge(Knowledge knowledge) {
		this.knowledge = knowledge;
	}
	
	public Object getComment() {
		return comment;
	}
	
	public void setComment(Object comment) {
		this.comment = comment;
	}
	
	public Object getLabels() {
		return labels;
	}
	
	public void setLabels(Object labels) {
		this.labels = labels;
	}
	
	public String getAuthorName() {
		return authorName;
	}

	public void setAuthorName(String authorName) {
		this.authorName = authorName;
	}

	public int getIsCollect() {
		return isCollect;
	}
	public void setIsCollect(int isCollect) {
		this.isCollect = isCollect;
	}
	
}
