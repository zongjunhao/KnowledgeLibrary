package com.syzc.common.kit;

import com.syzc.common.model.Knowledge;

public class KnowledgeWithText {
	
	private Knowledge knowledge;
	private String k_name;
	private String k_text;
	private int isCollect;

	public Knowledge getKnowledge() {
		return knowledge;
	}

	public void setKnowledge(Knowledge knowledge) {
		this.knowledge = knowledge;
	}

	public String getK_name() {
		return k_name;
	}

	public void setK_name(String k_name) {
		this.k_name = k_name;
	}

	public String getK_text() {
		return k_text;
	}

	public void setK_text(String k_text) {
		this.k_text = k_text;
	}

	public int getIsCollect() {
		return isCollect;
	}

	public void setIsCollect(int isCollect) {
		this.isCollect = isCollect;
	}
}
