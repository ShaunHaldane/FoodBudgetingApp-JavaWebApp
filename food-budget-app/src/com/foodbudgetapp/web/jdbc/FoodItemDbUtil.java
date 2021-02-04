package com.foodbudgetapp.web.jdbc;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import javax.sql.DataSource;

public class FoodItemDbUtil {

	private DataSource dataSource;

	public FoodItemDbUtil(DataSource theDataSource) {
		dataSource = theDataSource;
	}

	public List<FoodItemForPermanentStorage> getFoodItems() throws Exception {

		List<FoodItemForPermanentStorage> Items = new ArrayList<>();

		Connection myConn = null;
		Statement myStmt = null;
		ResultSet myRs = null;

		try {

			// get a connection
			myConn = dataSource.getConnection();

			// create sql statement
			String sql = "SELECT * FROM all_items";
			myStmt = myConn.createStatement();

			// execute query
			myRs = myStmt.executeQuery(sql);

			// process result set
			while (myRs.next()) {

				// retrieve data from result set row
				String item = myRs.getString("item");
				String purchaseDate = myRs.getString("purchase_date");
				float price = myRs.getFloat("price");

				// create new food item object
				FoodItemForPermanentStorage tempItem = new FoodItemForPermanentStorage(item, purchaseDate, price);

				// add it to the list of food items
				Items.add(tempItem);
			}
		}

		finally {
			// close JDBC objects
			close(myConn, myStmt, myRs);
		}

		return Items;
	}

	private void close(Connection myConn, Statement myStmt, ResultSet myRs) {

		try {
			if (myRs != null) {
				myRs.close();
			}

			if (myStmt != null) {
				myStmt.close();
			}

			if (myConn != null) {
				myConn.close();
			}
		} catch (Exception exc) {
			exc.printStackTrace();
		}

	}
	

	public void addFoodItem(FoodItem theFoodItem, FoodItemForPermanentStorage theFoodItemForPermanentStorage) throws Exception {
		
		// get and format input date for all items database
		Date today = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy"); 
		String purchaseDate=sdf.format(today);

		Connection myConn = null;
		PreparedStatement myStmtStock = null;
		PreparedStatement myStmtAllItems = null;

		try {

			// get DB connection
			myConn = dataSource.getConnection();

			// create sql statement to insert items into current stock table
			String sqlToInsertIntoStock = "insert into current_items " + "(item, expiry_date, price) " + "values (?, ?, ?)";
			
			// create sql statements to insert into all items table
			String sqlToInsertIntoAllItems = "insert into all_items " + "(item, purchase_date, price) " + "values (?, ?, ?)";
			
			myStmtStock = myConn.prepareStatement(sqlToInsertIntoStock);
			myStmtAllItems = myConn.prepareStatement(sqlToInsertIntoAllItems);

			// set the params to go into stock table
			myStmtStock.setString(1, theFoodItem.getItem());
			myStmtStock.setString(2, theFoodItem.getExpiryDate());
			myStmtStock.setFloat(3, theFoodItem.getPrice());
			
			// set the params to go into all items table
			myStmtAllItems.setString(1, theFoodItemForPermanentStorage.getItem());
			myStmtAllItems.setString(2, theFoodItemForPermanentStorage.getPurchaseDate());
			myStmtAllItems.setFloat(3, theFoodItemForPermanentStorage.getPrice());

			// execute sql inserts
			myStmtStock.execute();
			myStmtAllItems.execute();

		} finally {
			// clean up JDBC objects
			close(myConn, myStmtStock, null);
			close(myConn, myStmtAllItems, null);
		}

	}

	public FoodItem getFoodItem(String theFoodItemId) throws Exception {

		FoodItem theFoodItem = null;

		Connection myConn = null;
		PreparedStatement myStmt = null;
		ResultSet myRs = null;
		int foodItemId;

		try {

			// convert food item id to int
			foodItemId = Integer.parseInt(theFoodItemId);

			// get connection to database
			myConn = dataSource.getConnection();

			// create sql to get selected student
			String sql = "select * from current_items where id=?";

			// create prepared statement
			myStmt = myConn.prepareStatement(sql);

			// set params
			myStmt.setInt(1, foodItemId);

			// execute statement
			myRs = myStmt.executeQuery();

			// retrieve data from result set row
			if (myRs.next()) {
				String item = myRs.getString("item");
				String expiryDate = myRs.getString("expiry_date");
				float price = myRs.getFloat("price");

				// use the food item id to construct new food item object
				theFoodItem = new FoodItem(foodItemId, item, expiryDate, price);

			} else {
				throw new Exception("could not find food item with Id: " + foodItemId);
			}

			return theFoodItem;

		} finally {
			// clean up JDBC objects
			close(myConn, myStmt, myRs);
		}

	}

	public void editFoodItem(FoodItem theFoodItem) throws Exception {

		Connection myConn = null;
		PreparedStatement myStmt = null;

		try {

			// get db connection
			myConn = dataSource.getConnection();

			// create SQL update statement
			String sql = "update current_items " + "set item=?, expiry_date=?, price=? " + "where id=?";

			// prepare statement
			myStmt = myConn.prepareStatement(sql);

			// set params
			myStmt.setString(1, theFoodItem.getItem());
			myStmt.setString(2, theFoodItem.getExpiryDate());
			myStmt.setFloat(3, theFoodItem.getPrice());
			myStmt.setInt(4, theFoodItem.getId());

			// execute SQL statement
			myStmt.execute();

		} finally {
			// clean up JDBC objects
			close(myConn, myStmt, null);
		}

	}

	public void wasteFoodItem(String theFoodItemId) throws Exception {
		
		// get and format input date for all items database
		Date today = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy"); 
		String disposeDate=sdf.format(today);

		Connection myConn = null;
		PreparedStatement myStmtDeleteFromStock = null;
		PreparedStatement myStmtInsertToWastedItems = null;
		PreparedStatement myStmtGetFoodItemData = null;

		try {

			int foodItemId = Integer.parseInt(theFoodItemId);

			myConn = dataSource.getConnection();
			

			String sqlDeleteFromStock = "delete from current_items where id=?";
			
			String sqlInsertToWastedItems = "insert into wasted_items " + "(item, dispose_date, price) " + "values (?, ?, ?)";
			

			myStmtDeleteFromStock = myConn.prepareStatement(sqlDeleteFromStock);
			
			myStmtInsertToWastedItems = myConn.prepareStatement(sqlInsertToWastedItems);
			
			
			String item = this.getFoodItem(theFoodItemId).getItem();
			float price = this.getFoodItem(theFoodItemId).getPrice();

			
			// set the params to go into wasted items table
			myStmtInsertToWastedItems.setString(1, item);
			myStmtInsertToWastedItems.setString(2, disposeDate);
			myStmtInsertToWastedItems.setFloat(3, price);
			
			myStmtDeleteFromStock.setInt(1, foodItemId);
			
			myStmtInsertToWastedItems.execute();
			myStmtDeleteFromStock.execute();
			

		} finally {
			close(myConn, myStmtGetFoodItemData, null);
			close(myConn, myStmtInsertToWastedItems, null);
			close(myConn, myStmtDeleteFromStock, null);

		}

	}
	
	public void useFoodItem(String theFoodItemId) throws Exception {

		// get and format input date for all items database
		Date today = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy"); 
		String usedDate=sdf.format(today);

		Connection myConn = null;
		PreparedStatement myStmtDeleteFromStock = null;
		PreparedStatement myStmtInsertToUsedItems = null;
		PreparedStatement myStmtGetFoodItemData = null;

		try {

			int foodItemId = Integer.parseInt(theFoodItemId);

			myConn = dataSource.getConnection();
			

			String sqlDeleteFromStock = "delete from current_items where id=?";
			
			String sqlInsertToUsedItems = "insert into used_items " + "(item, used_date, price) " + "values (?, ?, ?)";
			

			myStmtDeleteFromStock = myConn.prepareStatement(sqlDeleteFromStock);
			
			myStmtInsertToUsedItems = myConn.prepareStatement(sqlInsertToUsedItems);
			
			
			String item = this.getFoodItem(theFoodItemId).getItem();
			float price = this.getFoodItem(theFoodItemId).getPrice();

			
			// set the params to go into used items table
			myStmtInsertToUsedItems.setString(1, item);
			myStmtInsertToUsedItems.setString(2, usedDate);
			myStmtInsertToUsedItems.setFloat(3, price);
			
			myStmtDeleteFromStock.setInt(1, foodItemId);
			
			myStmtInsertToUsedItems.execute();
			myStmtDeleteFromStock.execute();
			

		} finally {
			close(myConn, myStmtGetFoodItemData, null);
			close(myConn, myStmtInsertToUsedItems, null);
			close(myConn, myStmtDeleteFromStock, null);

		}

	}

	public List<FoodItem> getFoodItemsAccordingToExpiryDate() throws Exception {
		
		// get and format todays date
		Date today = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); 
		String dateString = sdf.format(today);
		String parsedDateString = dateString.substring(5, 7) + dateString.substring(8);
		int parsedDateInt = Integer.parseInt(parsedDateString);
		
		int dateTodayDay = Integer.parseInt(dateString.substring(8));
		int dateTodayMonth = Integer.parseInt(dateString.substring(5, 7));
		
		List<FoodItem> foodItems = new ArrayList<FoodItem>();

		Connection myConn = null;
		Statement myStmt = null;
		ResultSet myRs = null;

		try {

			// get a connection
			myConn = dataSource.getConnection();

			// create sql statement
			String sql = "SELECT * FROM current_items";
			myStmt = myConn.createStatement();

			// execute query
			myRs = myStmt.executeQuery(sql);

			// process result set
			while (myRs.next()) {

				// retrieve data from result set row
				int id = myRs.getInt("id");
				String item = myRs.getString("item");
				String expiryDate = myRs.getString("expiry_date");	
				float price = myRs.getFloat("price");
				
//				31-01-2021
				int parsedExpiryDateInt = Integer.parseInt(expiryDate.substring(3, 5) + expiryDate.substring(0, 2));
				
				int timeTillExpired = parsedExpiryDateInt - parsedDateInt;
				
				int parsedExpiryDateDays = Integer.parseInt(expiryDate.substring(0, 2));
				int parsedExpiryDateMonths = Integer.parseInt(expiryDate.substring(3, 5));

				int daysTillExpired = parsedExpiryDateDays - dateTodayDay;
				int monthsTillExpired = parsedExpiryDateMonths - dateTodayMonth;
				
				// create new food item object
				FoodItem tempFoodItem = new FoodItem(id, item, expiryDate, price, timeTillExpired, daysTillExpired, monthsTillExpired);

				// add it to the list of food items
				foodItems.add(tempFoodItem);
			}
		}

		finally {
			// close JDBC objects
			close(myConn, myStmt, myRs);
		}
		
		Collections.sort(foodItems, FoodItem.timeTillExpiry);
		
		return foodItems;
}
	

	public List<Double> getPricesForMonth() {
		
		ArrayList<Double> totalSpentThisMonth = new ArrayList();
		
		totalSpentThisMonth.add(2.22);
		totalSpentThisMonth.add(3.22);
		totalSpentThisMonth.add(4.22);
		
		System.out.println(totalSpentThisMonth);
    	return totalSpentThisMonth;
	}

	public List<FoodItem> getWastedItems() throws Exception {
		
		List<FoodItem> Items = new ArrayList<>();

		Connection myConn = null;
		Statement myStmt = null;
		ResultSet myRs = null;

		try {

			// get a connection
			myConn = dataSource.getConnection();

			// create sql statement
			String sql = "SELECT * FROM wasted_items";
			myStmt = myConn.createStatement();

			// execute query
			myRs = myStmt.executeQuery(sql);

			// process result set
			while (myRs.next()) {

				// retrieve data from result set row
				String item = myRs.getString("item");
				String disposeDate = myRs.getString("dispose_date");
				float price = myRs.getFloat("price");

				// create new food item object
				FoodItem tempItem = new FoodItem(item, disposeDate, price);

				// add it to the list of food items
				Items.add(tempItem);
			}
		}

		finally {
			// close JDBC objects
			close(myConn, myStmt, myRs);
		}

		return Items;
	}
}
