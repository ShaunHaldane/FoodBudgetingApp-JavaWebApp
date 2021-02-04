package com.foodbudgetapp.web.jdbc;
import java.util.Comparator;

import java.sql.Date;

public class FoodItem {

	private int id;
	private String item;
	private String expiryDate;
	private float price;
	private int daysTillExpired;
	private int monthsTillExpired;
	private int timeTillExpired;

	public FoodItem(int id, String item, String expiryDate, float price) {
		this.id = id;
		this.item = item;
		this.expiryDate = expiryDate;
		this.price = price;
	}
	
	public FoodItem(String item, String expiryDate, float price) {
		this.item = item;
		this.expiryDate = expiryDate;
		this.price = price;
	}
	
	public FoodItem(int id, String item, String expiryDate, float price, int timeTillExpired, int daysTillExpired, int monthsTillExpired) {
		this.id = id;
		this.item = item;
		this.expiryDate = expiryDate;
		this.price = price;
		this.daysTillExpired = daysTillExpired;
		this.monthsTillExpired = monthsTillExpired;
		this.timeTillExpired = timeTillExpired;
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

	public String getExpiryDate() {
		return expiryDate;
	}

	public void setExpiryDate(String expiryDate) {
		this.expiryDate = expiryDate;
	}

	public float getPrice() {
		return price;
	}

	public void setPrice(float price) {
		this.price = price;
	}
	
	public int getDaysTillExpired() {
		return daysTillExpired;
	}

	public void setDaysTillExpired(int parsedExpiryDateDays) {
		this.daysTillExpired = parsedExpiryDateDays;
	}
	
	public int getMonthsTillExpired() {
		return monthsTillExpired;
	}

	public void setMonthsTillExpired(int parsedExpiryDateMonths) {
		this.monthsTillExpired = parsedExpiryDateMonths;
	}
	
	public String getTimeTillExpiredMessage() {
		if (this.daysTillExpired == -1 && this.monthsTillExpired == 0) {
			return "Item has expired 1 day ago";
		} else if (this.daysTillExpired < -1 && this.monthsTillExpired == 0) {
			return "Item has expired " + (this.daysTillExpired*-1) + " days ago";
		} else if (this.timeTillExpired == 0 && this.monthsTillExpired == 0) {
			return "Use item today";
		} else if (this.timeTillExpired == 1 && this.monthsTillExpired == 0) {
			return "1 day till expired";
		} else if (this.timeTillExpired >= 2 && this.monthsTillExpired == 0) {
			return this.daysTillExpired + " days till expired";
		} else {
			return "More than a month till expired";
		}
	}
	
	public int getTimeTillExpired() {
		return timeTillExpired;
	}

	public void setTimeTillExpired(int parsedExpiryDate) {
		this.timeTillExpired = parsedExpiryDate;
	}

	@Override
	public String toString() {
		return "FoodItem [id=" + id + ", item=" + item + ", expiryDate=" + expiryDate + ", price=" + price + "]";
	}

    // Comparator for sorting the list by days till expired
    public static Comparator<FoodItem> timeTillExpiry = new Comparator<FoodItem>() {

	public int compare(FoodItem item1, FoodItem item2) {

	   int foodItem1 = item1.getTimeTillExpired();
	   int foodItem2 = item2.getTimeTillExpired();

	   // In decending order
	   return foodItem1 - foodItem2;

   }};

}
