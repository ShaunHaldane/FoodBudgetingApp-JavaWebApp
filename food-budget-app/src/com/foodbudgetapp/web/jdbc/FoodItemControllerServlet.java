package com.foodbudgetapp.web.jdbc;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

/**
 * Servlet implementation class FoodItemControllerServlet
 */
@WebServlet("/FoodItemControllerServlet")
public class FoodItemControllerServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private FoodItemDbUtil foodItemDbUtil;

	@Resource(name = "jdbc/food_budgeting_app")
	private DataSource dataSource;

	@Override
	public void init() throws ServletException {
//		super.init();

		// create student db util and pass in the conn pool / datasource
		try {
			foodItemDbUtil = new FoodItemDbUtil(dataSource);
		} catch (Exception exc) {
			throw new ServletException(exc);
		}
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		try {

			// read the "command" parameter
			String theCommand = request.getParameter("command");

			// if the command is missing, then default to listing items in stock
			if (theCommand == null) {
				theCommand = "LIST";
			}

			// route to the appropriate method
			switch (theCommand) {
			case "LIST":
				listFoodItemsAccordingToExpiryDate(request, response);
				break;

			case "LOAD":
				loadFoodItem(request, response);
				break;

			case "EDIT":
				editFoodItem(request, response);
				break;

			case "WASTE":
				wasteFoodItem(request, response);
				break;

			case "USE":
				useFoodItem(request, response);
				break;
				
			default:
				listFoodItemsAccordingToExpiryDate(request, response);
			}

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        try {
            // read the "command" parameter
            String theCommand = request.getParameter("command");
                    
            // route to the appropriate method
            switch (theCommand) {
                            
            case "ADD":
                addFoodItem(request, response);
                break;
                                
            default:
                listFoodItemsAccordingToExpiryDate(request, response);
            }
                
        }
        catch (Exception exc) {
            throw new ServletException(exc);
        }
        
    }

	private void listFoodItemsAccordingToExpiryDate(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// get food items from DbUtils class
		List<FoodItem> foodItems = foodItemDbUtil.getFoodItemsAccordingToExpiryDate();
		List<FoodItemForPermanentStorage> monthlyPrices = foodItemDbUtil.getFoodItems();
		List<FoodItem> wastedItemsPrices = foodItemDbUtil.getWastedItems();

		// add food items to the request
		request.setAttribute("FOOD_ITEMS_LIST", foodItems);
		request.setAttribute("MONTHLY_PRICES_LIST", monthlyPrices);
		request.setAttribute("WASTED_ITEMS__PRICE_LIST", wastedItemsPrices);
		
		// send to JSP page (view)
		RequestDispatcher dispatcher = request.getRequestDispatcher("/list-current-items.jsp");
		dispatcher.forward(request, response);
		
	}

	private void wasteFoodItem(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String theFoodItemId = request.getParameter("foodItemId");

		foodItemDbUtil.wasteFoodItem(theFoodItemId);

		listFoodItemsAccordingToExpiryDate(request, response);

	}

	private void useFoodItem(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String theFoodItemId = request.getParameter("foodItemId");

		foodItemDbUtil.useFoodItem(theFoodItemId);

		listFoodItemsAccordingToExpiryDate(request, response);

	}

	private void editFoodItem(HttpServletRequest request, HttpServletResponse response) throws Exception {

		// read food item info from form data
		int id = Integer.parseInt(request.getParameter("foodItemId"));
		String item = request.getParameter("item");
		String expiryDate = request.getParameter("expiryDate");
		float price = Float.parseFloat(request.getParameter("price"));

		// create a new food item object
		FoodItem theFoodItem = new FoodItem(id, item, expiryDate, price);

		// perform update on database
		foodItemDbUtil.editFoodItem(theFoodItem);

		// send them back to the items in stock list page
		listFoodItemsAccordingToExpiryDate(request, response);
	}

	private void loadFoodItem(HttpServletRequest request, HttpServletResponse response) throws Exception {

		// read food item id from form data
		String theFoodItemId = request.getParameter("foodItemId");

		// get food item from database with DbUtil class
		FoodItem theFoodItem = foodItemDbUtil.getFoodItem(theFoodItemId);

		// place food item in the request attribute
		request.setAttribute("THE_FOOD_ITEM", theFoodItem);

		// send to jsp page: edit-food-item.jsp
		RequestDispatcher dispatcher = request.getRequestDispatcher("/edit-food-item.jsp");
		dispatcher.forward(request, response);
	}

	private void addFoodItem(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// get and format input date for all items database
		Date today = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy"); 
		String purchaseDate = sdf.format(today);

		// read food item info from form data
		String item = request.getParameter("item");
		String expiryDate = request.getParameter("expiryDate");
		float price = Float.parseFloat(request.getParameter("price"));

		// create a new food item object
		FoodItem theFoodItem = new FoodItem(item, expiryDate, price);
		FoodItemForPermanentStorage theFoodItemForPermanentStorage = new FoodItemForPermanentStorage(item, purchaseDate, price);

		// add the food item to the database
		foodItemDbUtil.addFoodItem(theFoodItem, theFoodItemForPermanentStorage);
		
        // send back to main page
        // SEND AS REDIRECT to avoid multiple-browser reload issue
        response.sendRedirect(request.getContextPath() + "/FoodItemControllerServlet?command=LIST");
	}
}
