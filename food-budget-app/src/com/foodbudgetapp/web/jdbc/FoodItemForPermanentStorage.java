package com.foodbudgetapp.web.jdbc;

public class FoodItemForPermanentStorage {
	private int id;
	private String item;
	private String purchaseDate;
	private float price;
	
	public FoodItemForPermanentStorage(String item, String purchaseDate, float price) {
		this.item = item;
		this.purchaseDate = purchaseDate;
		this.price = price;
	}
	
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getItem() {
		return item;
	}

	public void setItem(String item) {
		this.item = item;
	}

	public String getPurchaseDate() {
		return purchaseDate;
	}

	public void setPurchaseDate(String purchaseDate) {
		this.purchaseDate = purchaseDate;
	}

	public float getPrice() {
		return price;
	}

	public void setPrice(float price) {
		this.price = price;
	}
}
