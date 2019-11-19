package com.syzc.common.model;

public class CollectionAState {
	
	private Knowledge knowledge;
	private int isCollect;
	
//	public CollectionAState(Knowledge knowledge, int flag) {
//		
//		this.knowledge = knowledge;
//		this.isCollect = flag;
//	}

//	@Override
//	public String toString() {
//		return "CollectionAState [knowledge=" + knowledge + ", isCollect=" + isCollect + "]";
//	}

	public Knowledge getKnowledge() {
		return knowledge;
	}

	public void setKnowledge(Knowledge knowledge) {
		this.knowledge = knowledge;
	}

	public int getIsCollect() {
		return isCollect;
	}

	public void setIsCollect(int isCollect) {
		this.isCollect = isCollect;
	}

	
}
