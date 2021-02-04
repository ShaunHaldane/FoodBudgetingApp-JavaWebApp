

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>

<head>
<title>Food Budgeting App</title>

<style>

html, body{
	margin-left:15px; margin-right:15px; 
	padding:0px; 
	font-family:Verdana, Arial, Helvetica, sans-serif;
}

.header-picture {
	text-align: center;
	color: white;
	margin-top: 0;
	padding-top: 25px;
	height: 120px;
	width: 80%;
	display: block;
  	margin-left: auto;
 	margin-right: auto;
}

.header-text {
	height: 20vh;
	display: block;
  	margin-left: auto;
 	margin-right: auto;
  	width: 50%;
  	height: 80px;
  	margin-top: -5px
}

table {   
	border-collapse:collapse;
	border-bottom:1px solid black;
	font-family: Tahoma,Verdana,Segoe,sans-serif;
	width:80%;
  	margin-left: auto;
 	margin-right: auto;
}
 
th {
	border-bottom:1px solid gray;
	background:none repeat scroll 0 0 #0775d3;
	padding:10px;
	color: #FFFFFF;
}

tr {
	border-top:1px solid gray;
	text-align:center;	
}
 
#wrapper {width: 80%; margin-top: 40px; display: block; margin-left: auto; margin-right: auto;}
#header {width: 100%; background: #0775d3; margin-top: 0px; padding:15px 0px 15px 0px;}
#header h2 {width: 100%; margin:auto; color: #FFFFFF; text-align: center}
#container {width: 100%; margin:auto}
#container h3 {color: #000;}
#container #content {margin-top: 20px;}

.add-food-item-button {
	border: 1px solid black; 
	border-radius: 5px; 
	padding: 10px; 
	font-size: 12px;
	font-weight: bold; 
	background: #0775d3;
	margin-top: 20px;
	color: white;
	display: block;
  	margin-left: auto;
 	margin-right: auto;
}

.add-food-item-button:hover {
	cursor: pointer;
}

.expenditures-chart {
	margin-top: 100px;
	height: 450px; 
	width: 80%;
	display: block;
  	margin-left: auto;
 	margin-right: auto;
}

.chart-label-x {
	text-align: center; 
	color:#525252}

.button-container {
	display:flex; 
	align-items: 
	center; margin-left:auto; 
	margin-right:auto; 
	width:80%
}

.graph-button {
	border: 1px solid black; 
	border-radius: 5px; 
	padding: 10px; 
	font-size: 12px;
	font-weight: bold; 
	background: white;
	margin-top: 10px;
	color: black;
	display: block;
  	margin-left: auto;
 	margin-right: auto;
}

.graph-button:hover {
	cursor: pointer;
}

.footer {
	text-align: center;
	height: 50px;
	width: 100%;
	background-color: #0775d3;
	color: white;
	padding-top: 20px;
	margin-top: 100px;
	display: block;
  	margin-left: auto;
 	margin-right: auto;
 	width: 80%
}


</style>
</head>

<body>

<div class="header-picture">
<h1 class="header-text">Your Food Budgeting App</h1>
</div>

<div id="wrapper">
<div id="header">
<h2>Items In Stock</h2>
</div>
</div>

<div id="container">
<div id="content">

<table>
<tr>
<th>Item</th>
<th>Expiry Date</th>
<th>Expiry Info</th>
<th>Edit</th>
<th>Waste</th>
<th>Use</th>
</tr>

<c:forEach var="tempFoodItem" items="${FOOD_ITEMS_LIST}">

<!-- set up link for each food item -->

<c:url var="tempLink" value="FoodItemControllerServlet" >
<c:param name="command" value="LOAD" />
<c:param name="foodItemId" value="${tempFoodItem.id}" />
</c:url>

<!-- set up link to waste food item -->

<c:url var="wasteLink" value="FoodItemControllerServlet" >
<c:param name="command" value="WASTE" />
<c:param name="foodItemId" value="${tempFoodItem.id}" />
</c:url>

<!-- set up link to use food item -->

<c:url var="usedLink" value="FoodItemControllerServlet" >
<c:param name="command" value="USE" />
<c:param name="foodItemId" value="${tempFoodItem.id}" />
</c:url>

<tr> 
	<td>${tempFoodItem.item}</td>
	<td> ${tempFoodItem.expiryDate} </td>
	<td> ${tempFoodItem.timeTillExpiredMessage} </td>
	<td> <a href="${tempLink}">Edit Item</a></td>
	<td><a href="${wasteLink}" onclick="if (!(confirm('Are you sure you want to waste this food item?'))) return false">Wasted</a></td>
	<td><a href="${usedLink}" onclick="if (!(confirm('Are you sure you want to remove this food item?'))) return false">Used</a></td>
</tr>
</c:forEach>
</table>
</div>
</div>

<input type="button" value="Add Food Item"
onclick="window.location.href='add-food-item.jsp'; return false;"
class="add-food-item-button" />



<div id="chartContainer" class="expenditures-chart"></div>
<p class="chart-label-x">Days</p>

<div class="button-container">
<input type="button" value="Spent Last Month"
onclick="mm=mm-1; lastMonthSpendButtonClicked();"
class="graph-button" />

<input type="button" value="Spent This Year"
onclick="thisYearSpendButtonClicked()"
class="graph-button" />

<input type="button" value="Money Wasted"
onclick="moneyWastedButtonClicked()"
class="graph-button" />

<input type="button" value="Reset Graph"
onclick="window.location.href='FoodItemControllerServlet';"
class="graph-button" />

</div>

<div class="footer">Created by Shaun Haldane<br> 2021</div>

<script>
var priceArrayJan = [];
var priceArrayFeb = [];
var priceArrayMar = [];
var priceArrayApr = [];
var priceArrayMay = [];
var priceArrayJun = [];
var priceArrayJul = [];
var priceArrayAug = [];
var priceArraySep = [];
var priceArrayOct = [];
var priceArrayNov = [];
var priceArrayDec = [];

var jan1 = 0;
var jan2 = 0;
var jan3 = 0;
var jan4 = 0;
var jan5 = 0;
var jan6 = 0;
var jan7 = 0;
var jan8 = 0;
var jan9 = 0;
var jan10 = 0;
var jan11 = 0;
var jan12 = 0;
var jan13 = 0;
var jan14 = 0;
var jan15 = 0;
var jan16 = 0;
var jan17 = 0;
var jan18 = 0;
var jan19 = 0;
var jan20 = 0;
var jan21 = 0;
var jan22 = 0;
var jan23 = 0;
var jan24 = 0;
var jan25 = 0;
var jan26 = 0;
var jan27 = 0;
var jan28 = 0;
var jan29 = 0;
var jan30 = 0;
var jan31 = 0;

var feb1 = 0;
var feb2 = 0;
var feb3 = 0;
var feb4 = 0;
var feb5 = 0;
var feb6 = 0;
var feb7 = 0;
var feb8 = 0;
var feb9 = 0;
var feb10 = 0;
var feb11 = 0;
var feb12 = 0;
var feb13 = 0;
var feb14 = 0;
var feb15 = 0;
var feb16 = 0;
var feb17 = 0;
var feb18 = 0;
var feb19 = 0;
var feb20 = 0;
var feb21 = 0;
var feb22 = 0;
var feb23 = 0;
var feb24 = 0;
var feb25 = 0;
var feb26 = 0;
var feb27 = 0;
var feb28 = 0;

var mar1 = 0;
var mar2 = 0;
var mar3 = 0;
var mar4 = 0;
var mar5 = 0;
var mar6 = 0;
var mar7 = 0;
var mar8 = 0;
var mar9 = 0;
var mar10 = 0;
var mar11 = 0;
var mar12 = 0;
var mar13 = 0;
var mar14 = 0;
var mar15 = 0;
var mar16 = 0;
var mar17 = 0;
var mar18 = 0;
var mar19 = 0;
var mar20 = 0;
var mar21 = 0;
var mar22 = 0;
var mar23 = 0;
var mar24 = 0;
var mar25 = 0;
var mar26 = 0;
var mar27 = 0;
var mar28 = 0;
var mar29 = 0;
var mar30 = 0;
var mar31 = 0;

var apr1 = 0;
var apr2 = 0;
var apr3 = 0;
var apr4 = 0;
var apr5 = 0;
var apr6 = 0;
var apr7 = 0;
var apr8 = 0;
var apr9 = 0;
var apr10 = 0;
var apr11 = 0;
var apr12 = 0;
var apr13 = 0;
var apr14 = 0;
var apr15 = 0;
var apr16 = 0;
var apr17 = 0;
var apr18 = 0;
var apr19 = 0;
var apr20 = 0;
var apr21 = 0;
var apr22 = 0;
var apr23 = 0;
var apr24 = 0;
var apr25 = 0;
var apr26 = 0;
var apr27 = 0;
var apr28 = 0;
var apr29 = 0;
var apr30 = 0;

var may1 = 0;
var may2 = 0;
var may3 = 0;
var may4 = 0;
var may5 = 0;
var may6 = 0;
var may7 = 0;
var may8 = 0;
var may9 = 0;
var may10 = 0;
var may11 = 0;
var may12 = 0;
var may13 = 0;
var may14 = 0;
var may15 = 0;
var may16 = 0;
var may17 = 0;
var may18 = 0;
var may19 = 0;
var may20 = 0;
var may21 = 0;
var may22 = 0;
var may23 = 0;
var may24 = 0;
var may25 = 0;
var may26 = 0;
var may27 = 0;
var may28 = 0;
var may29 = 0;
var may30 = 0;
var may31 = 0;

var jun1 = 0;
var jun2 = 0;
var jun3 = 0;
var jun4 = 0;
var jun5 = 0;
var jun6 = 0;
var jun7 = 0;
var jun8 = 0;
var jun9 = 0;
var jun10 = 0;
var jun11 = 0;
var jun12 = 0;
var jun13 = 0;
var jun14 = 0;
var jun15 = 0;
var jun16 = 0;
var jun17 = 0;
var jun18 = 0;
var jun19 = 0;
var jun20 = 0;
var jun21 = 0;
var jun22 = 0;
var jun23 = 0;
var jun24 = 0;
var jun25 = 0;
var jun26 = 0;
var jun27 = 0;
var jun28 = 0;
var jun29 = 0;
var jun30 = 0;

var jul1 = 0;
var jul2 = 0;
var jul3 = 0;
var jul4 = 0;
var jul5 = 0;
var jul6 = 0;
var jul7 = 0;
var jul8 = 0;
var jul9 = 0;
var jul10 = 0;
var jul11 = 0;
var jul12 = 0;
var jul13 = 0;
var jul14 = 0;
var jul15 = 0;
var jul16 = 0;
var jul17 = 0;
var jul18 = 0;
var jul19 = 0;
var jul20 = 0;
var jul21 = 0;
var jul22 = 0;
var jul23 = 0;
var jul24 = 0;
var jul25 = 0;
var jul26 = 0;
var jul27 = 0;
var jul28 = 0;
var jul29 = 0;
var jul30 = 0;
var jul31 = 0;

var aug1 = 0;
var aug2 = 0;
var aug3 = 0;
var aug4 = 0;
var aug5 = 0;
var aug6 = 0;
var aug7 = 0;
var aug8 = 0;
var aug9 = 0;
var aug10 = 0;
var aug11 = 0;
var aug12 = 0;
var aug13 = 0;
var aug14 = 0;
var aug15 = 0;
var aug16 = 0;
var aug17 = 0;
var aug18 = 0;
var aug19 = 0;
var aug20 = 0;
var aug21 = 0;
var aug22 = 0;
var aug23 = 0;
var aug24 = 0;
var aug25 = 0;
var aug26 = 0;
var aug27 = 0;
var aug28 = 0;
var aug29 = 0;
var aug30 = 0;
var aug31 = 0;

var sep1 = 0;
var sep2 = 0;
var sep3 = 0;
var sep4 = 0;
var sep5 = 0;
var sep6 = 0;
var sep7 = 0;
var sep8 = 0;
var sep9 = 0;
var sep10 = 0;
var sep11 = 0;
var sep12 = 0;
var sep13 = 0;
var sep14 = 0;
var sep15 = 0;
var sep16 = 0;
var sep17 = 0;
var sep18 = 0;
var sep19 = 0;
var sep20 = 0;
var sep21 = 0;
var sep22 = 0;
var sep23 = 0;
var sep24 = 0;
var sep25 = 0;
var sep26 = 0;
var sep27 = 0;
var sep28 = 0;
var sep29 = 0;
var sep30 = 0;

var oct1 = 0;
var oct2 = 0;
var oct3 = 0;
var oct4 = 0;
var oct5 = 0;
var oct6 = 0;
var oct7 = 0;
var oct8 = 0;
var oct9 = 0;
var oct10 = 0;
var oct11 = 0;
var oct12 = 0;
var oct13 = 0;
var oct14 = 0;
var oct15 = 0;
var oct16 = 0;
var oct17 = 0;
var oct18 = 0;
var oct19 = 0;
var oct20 = 0;
var oct21 = 0;
var oct22 = 0;
var oct23 = 0;
var oct24 = 0;
var oct25 = 0;
var oct26 = 0;
var oct27 = 0;
var oct28 = 0;
var oct29 = 0;
var oct30 = 0;
var oct31 = 0;

var nov1 = 0;
var nov2 = 0;
var nov3 = 0;
var nov4 = 0;
var nov5 = 0;
var nov6 = 0;
var nov7 = 0;
var nov8 = 0;
var nov9 = 0;
var nov10 = 0;
var nov11 = 0;
var nov12 = 0;
var nov13 = 0;
var nov14 = 0;
var nov15 = 0;
var nov16 = 0;
var nov17 = 0;
var nov18 = 0;
var nov19 = 0;
var nov20 = 0;
var nov21 = 0;
var nov22 = 0;
var nov23 = 0;
var nov24 = 0;
var nov25 = 0;
var nov26 = 0;
var nov27 = 0;
var nov28 = 0;
var nov29 = 0;
var nov30 = 0;

var dec1 = 0;
var dec2 = 0;
var dec3 = 0;
var dec4 = 0;
var dec5 = 0;
var dec6 = 0;
var dec7 = 0;
var dec8 = 0;
var dec9 = 0;
var dec10 = 0;
var dec11 = 0;
var dec12 = 0;
var dec13 = 0;
var dec14 = 0;
var dec15 = 0;
var dec16 = 0;
var dec17 = 0;
var dec18 = 0;
var dec19 = 0;
var dec20 = 0;
var dec21 = 0;
var dec22 = 0;
var dec23 = 0;
var dec24 = 0;
var dec25 = 0;
var dec26 = 0;
var dec27 = 0;
var dec28 = 0;
var dec29 = 0;
var dec30 = 0;
var dec31 = 0;

</script>

<c:forEach var="tempItem" items="${MONTHLY_PRICES_LIST}">
	
	<script>
	
	if(${tempItem.purchaseDate.substring(3, 5)} == "01") {
		
		if(${tempItem.purchaseDate.substring(0, 2)} == "01"){
			jan1 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "02"){
			jan2 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "03"){
			jan3 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "04"){
			jan4 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "05"){
			jan5 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "06"){
			jan6 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "07"){
			jan7 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "08"){
			jan8 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "09"){
			jan9 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "10"){
			jan10 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "11"){
			jan11 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "12"){
			jan12 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "13"){
			jan13 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "14"){
			jan14 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "15"){
			jan15 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "16"){
			jan16 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "17"){
			jan17 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "18"){
			jan18 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "19"){
			jan19 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "20"){
			jan20 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "21"){
			jan21 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "22"){
			jan22 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "23"){
			jan23 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "24"){
			jan24 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "25"){
			jan25 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "26"){
			jan26 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "27"){
			jan27 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "28"){
			jan28 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "29"){
			jan29 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "30"){
			jan30 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "31"){
			jan31 += parseFloat(${tempItem.price});
		}
	} 
	
	if(${tempItem.purchaseDate.substring(3, 5)} == "02") {
		if(${tempItem.purchaseDate.substring(0, 2)} == "01"){
			feb1 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "02"){
			feb2 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "03"){
			feb3 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "04"){
			feb4 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "05"){
			feb5 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "06"){
			feb6 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "07"){
			feb7 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "08"){
			feb8 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "09"){
			feb9 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "10"){
			feb10 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "11"){
			feb11 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "12"){
			feb12 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "13"){
			feb13 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "14"){
			feb14 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "15"){
			feb15 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "16"){
			feb16 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "17"){
			feb17 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "18"){
			feb18 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "19"){
			feb19 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "20"){
			feb20 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "21"){
			feb21 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "22"){
			feb22 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "23"){
			feb23 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "24"){
			feb24 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "25"){
			feb25 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "26"){
			feb26 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "27"){
			feb27 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "28"){
			feb28 += parseFloat(${tempItem.price});
		}
	}
	
	if(${tempItem.purchaseDate.substring(3, 5)} == "03") {
		if(${tempItem.purchaseDate.substring(0, 2)} == "01"){
			mar1 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "02"){
			mar2 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "03"){
			mar3 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "04"){
			mar4 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "05"){
			mar5 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "06"){
			mar6 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "07"){
			mar7 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "08"){
			mar8 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "09"){
			mar9 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "10"){
			mar10 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "11"){
			mar11 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "12"){
			mar12 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "13"){
			mar13 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "14"){
			mar14 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "15"){
			mar15 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "16"){
			mar16 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "17"){
			mar17 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "18"){
			mar18 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "19"){
			mar19 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "20"){
			mar20 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "21"){
			mar21 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "22"){
			mar22 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "23"){
			mar23 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "24"){
			mar24 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "25"){
			mar25 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "26"){
			mar26 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "27"){
			mar27 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "28"){
			mar28 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "29"){
			mar29 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "30"){
			mar30 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "31"){
			mar31 += parseFloat(${tempItem.price});
		}
	}
	
	if(${tempItem.purchaseDate.substring(3, 5)} == "04") {
		if(${tempItem.purchaseDate.substring(0, 2)} == "01"){
			apr1 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "02"){
			apr2 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "03"){
			apr3 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "04"){
			apr4 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "05"){
			apr5 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "06"){
			apr6 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "07"){
			apr7 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "08"){
			apr8 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "09"){
			apr9 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "10"){
			apr10 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "11"){
			apr11 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "12"){
			apr12 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "13"){
			apr13 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "14"){
			apr14 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "15"){
			apr15 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "16"){
			apr16 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "17"){
			apr17 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "18"){
			apr18 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "19"){
			apr19 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "20"){
			apr20 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "21"){
			apr21 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "22"){
			apr22 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "23"){
			apr23 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "24"){
			apr24 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "25"){
			apr25 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "26"){
			apr26 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "27"){
			apr27 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "28"){
			apr28 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "29"){
			apr29 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "30"){
			apr30 += parseFloat(${tempItem.price});
		}
	}
	
	if(${tempItem.purchaseDate.substring(3, 5)} == "05") {
		if(${tempItem.purchaseDate.substring(0, 2)} == "01"){
			may1 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "02"){
			may2 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "03"){
			may3 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "04"){
			may4 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "05"){
			may5 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "06"){
			may6 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "07"){
			may7 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "08"){
			may8 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "09"){
			may9 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "10"){
			may10 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "11"){
			may11 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "12"){
			may12 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "13"){
			may13 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "14"){
			may14 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "15"){
			may15 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "16"){
			may16 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "17"){
			may17 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "18"){
			may18 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "19"){
			may19 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "20"){
			may20 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "21"){
			may21 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "22"){
			may22 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "23"){
			may23 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "24"){
			may24 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "25"){
			may25 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "26"){
			may26 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "27"){
			may27 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "28"){
			may28 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "29"){
			may29 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "30"){
			may30 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "31"){
			may31 += parseFloat(${tempItem.price});
		}
	}
	
	if(${tempItem.purchaseDate.substring(3, 5)} == "06") {
		if(${tempItem.purchaseDate.substring(0, 2)} == "01"){
			jun1 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "02"){
			jun2 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "03"){
			jun3 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "04"){
			jun4 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "05"){
			jun5 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "06"){
			jun6 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "07"){
			jun7 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "08"){
			jun8 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "09"){
			jun9 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "10"){
			jun10 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "11"){
			jun11 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "12"){
			jun12 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "13"){
			jun13 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "14"){
			jun14 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "15"){
			jun15 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "16"){
			jun16 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "17"){
			jun17 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "18"){
			jun18 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "19"){
			jun19 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "20"){
			jun20 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "21"){
			jun21 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "22"){
			jun22 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "23"){
			jun23 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "24"){
			jun24 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "25"){
			jun25 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "26"){
			jun26 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "27"){
			jun27 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "28"){
			jun28 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "29"){
			jun29 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "30"){
			jun30 += parseFloat(${tempItem.price});
		}
	}
	
	if(${tempItem.purchaseDate.substring(3, 5)} == "07") {
		if(${tempItem.purchaseDate.substring(0, 2)} == "01"){
			jul1 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "02"){
			jul2 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "03"){
			jul3 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "04"){
			jul4 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "05"){
			jul5 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "06"){
			jul6 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "07"){
			jul7 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "08"){
			jul8 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "09"){
			jul9 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "10"){
			jul10 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "11"){
			jul11 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "12"){
			jul12 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "13"){
			jul13 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "14"){
			jul14 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "15"){
			jul15 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "16"){
			jul16 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "17"){
			jul17 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "18"){
			jul18 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "19"){
			jul19 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "20"){
			jul20 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "21"){
			jul21 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "22"){
			jul22 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "23"){
			jul23 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "24"){
			jul24 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "25"){
			jul25 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "26"){
			jul26 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "27"){
			jul27 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "28"){
			jul28 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "29"){
			jul29 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "30"){
			jul30 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "31"){
			jul31 += parseFloat(${tempItem.price});
		}
	}
	
	if(${tempItem.purchaseDate.substring(3, 5)} == "08") {
		if(${tempItem.purchaseDate.substring(0, 2)} == "01"){
			aug1 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "02"){
			aug2 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "03"){
			aug3 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "04"){
			aug4 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "05"){
			aug5 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "06"){
			aug6 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "07"){
			aug7 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "08"){
			aug8 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "09"){
			aug9 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "10"){
			aug10 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "11"){
			aug11 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "12"){
			aug12 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "13"){
			aug13 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "14"){
			aug14 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "15"){
			aug15 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "16"){
			aug16 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "17"){
			aug17 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "18"){
			aug18 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "19"){
			aug19 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "20"){
			aug20 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "21"){
			aug21 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "22"){
			aug22 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "23"){
			aug23 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "24"){
			aug24 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "25"){
			aug25 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "26"){
			aug26 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "27"){
			aug27 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "28"){
			aug28 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "29"){
			aug29 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "30"){
			aug30 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "31"){
			aug31 += parseFloat(${tempItem.price});
		}
	}
	
	if(${tempItem.purchaseDate.substring(3, 5)} == "09") {
		if(${tempItem.purchaseDate.substring(0, 2)} == "01"){
			sep1 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "02"){
			sep2 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "03"){
			sep3 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "04"){
			sep4 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "05"){
			sep5 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "06"){
			sep6 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "07"){
			sep7 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "08"){
			sep8 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "09"){
			sep9 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "10"){
			sep10 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "11"){
			sep11 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "12"){
			sep12 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "13"){
			sep13 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "14"){
			sep14 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "15"){
			sep15 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "16"){
			sep16 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "17"){
			sep17 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "18"){
			sep18 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "19"){
			sep19 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "20"){
			sep20 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "21"){
			sep21 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "22"){
			sep22 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "23"){
			sep23 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "24"){
			sep24 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "25"){
			sep25 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "26"){
			sep26 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "27"){
			sep27 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "28"){
			sep28 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "29"){
			sep29 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "30"){
			sep30 += parseFloat(${tempItem.price});
		}
	}
	
	if(${tempItem.purchaseDate.substring(3, 5)} == "10") {
		if(${tempItem.purchaseDate.substring(0, 2)} == "01"){
			oct1 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "02"){
			oct2 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "03"){
			oct3 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "04"){
			oct4 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "05"){
			oct5 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "06"){
			oct6 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "07"){
			oct7 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "08"){
			oct8 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "09"){
			oct9 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "10"){
			oct10 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "11"){
			oct11 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "12"){
			oct12 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "13"){
			oct13 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "14"){
			oct14 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "15"){
			oct15 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "16"){
			oct16 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "17"){
			oct17 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "18"){
			oct18 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "19"){
			oct19 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "20"){
			oct20 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "21"){
			oct21 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "22"){
			oct22 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "23"){
			oct23 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "24"){
			oct24 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "25"){
			oct25 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "26"){
			oct26 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "27"){
			oct27 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "28"){
			oct28 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "29"){
			oct29 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "30"){
			oct30 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "31"){
			oct31 += parseFloat(${tempItem.price});
		}
	}
	if(${tempItem.purchaseDate.substring(3, 5)} == "11") {
		if(${tempItem.purchaseDate.substring(0, 2)} == "01"){
			nov1 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "02"){
			nov2 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "03"){
			nov3 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "04"){
			nov4 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "05"){
			nov5 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "06"){
			nov6 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "07"){
			nov7 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "08"){
			nov8 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "09"){
			nov9 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "10"){
			nov10 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "11"){
			nov11 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "12"){
			nov12 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "13"){
			nov13 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "14"){
			nov14 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "15"){
			nov15 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "16"){
			nov16 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "17"){
			nov17 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "18"){
			nov18 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "19"){
			nov19 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "20"){
			nov20 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "21"){
			nov21 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "22"){
			nov22 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "23"){
			nov23 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "24"){
			nov24 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "25"){
			nov25 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "26"){
			nov26 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "27"){
			nov27 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "28"){
			nov28 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "29"){
			nov29 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "30"){
			nov30 += parseFloat(${tempItem.price});
		}
	}
	
	if(${tempItem.purchaseDate.substring(3, 5)} == "12") {
		if(${tempItem.purchaseDate.substring(0, 2)} == "01"){
			dec1 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "02"){
			dec2 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "03"){
			dec3 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "04"){
			dec4 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "05"){
			dec5 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "06"){
			dec6 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "07"){
			dec7 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "08"){
			dec8 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "09"){
			dec9 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "10"){
			dec10 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "11"){
			dec11 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "12"){
			dec12 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "13"){
			dec13 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "14"){
			dec14 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "15"){
			dec15 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "16"){
			dec16 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "17"){
			dec17 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "18"){
			dec18 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "19"){
			dec19 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "20"){
			dec20 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "21"){
			dec21 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "22"){
			dec22 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "23"){
			dec23 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "24"){
			dec24 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "25"){
			dec25 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "26"){
			dec26 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "27"){
			dec27 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "28"){
			dec28 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "29"){
			dec29 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "30"){
			dec30 += parseFloat(${tempItem.price});
		}
		if(${tempItem.purchaseDate.substring(0, 2)} == "31"){
			dec31 += parseFloat(${tempItem.price});
		}
	}
	
	
	</script>

</c:forEach>

<script>
priceArrayJan.push(jan1);
priceArrayJan.push(jan2);
priceArrayJan.push(jan3);
priceArrayJan.push(jan4);
priceArrayJan.push(jan5);
priceArrayJan.push(jan6);
priceArrayJan.push(jan7);
priceArrayJan.push(jan8);
priceArrayJan.push(jan9);
priceArrayJan.push(jan10);
priceArrayJan.push(jan11);
priceArrayJan.push(jan12);
priceArrayJan.push(jan13);
priceArrayJan.push(jan14);
priceArrayJan.push(jan15);
priceArrayJan.push(jan16);
priceArrayJan.push(jan17);
priceArrayJan.push(jan18);
priceArrayJan.push(jan19);
priceArrayJan.push(jan20);
priceArrayJan.push(jan21);
priceArrayJan.push(jan22);
priceArrayJan.push(jan23);
priceArrayJan.push(jan24);
priceArrayJan.push(jan25);
priceArrayJan.push(jan26);
priceArrayJan.push(jan27);
priceArrayJan.push(jan28);
priceArrayJan.push(jan29);
priceArrayJan.push(jan30);
priceArrayJan.push(jan31);

priceArrayFeb.push(feb1);
priceArrayFeb.push(feb2);
priceArrayFeb.push(feb3);
priceArrayFeb.push(feb4);
priceArrayFeb.push(feb5);
priceArrayFeb.push(feb6);
priceArrayFeb.push(feb7);
priceArrayFeb.push(feb8);
priceArrayFeb.push(feb9);
priceArrayFeb.push(feb10);
priceArrayFeb.push(feb11);
priceArrayFeb.push(feb12);
priceArrayFeb.push(feb13);
priceArrayFeb.push(feb14);
priceArrayFeb.push(feb15);
priceArrayFeb.push(feb16);
priceArrayFeb.push(feb17);
priceArrayFeb.push(feb18);
priceArrayFeb.push(feb19);
priceArrayFeb.push(feb20);
priceArrayFeb.push(feb21);
priceArrayFeb.push(feb22);
priceArrayFeb.push(feb23);
priceArrayFeb.push(feb24);
priceArrayFeb.push(feb25);
priceArrayFeb.push(feb26);
priceArrayFeb.push(feb27);
priceArrayFeb.push(feb28);

priceArrayMar.push(mar1);
priceArrayMar.push(mar2);
priceArrayMar.push(mar3);
priceArrayMar.push(mar4);
priceArrayMar.push(mar5);
priceArrayMar.push(mar6);
priceArrayMar.push(mar7);
priceArrayMar.push(mar8);
priceArrayMar.push(mar9);
priceArrayMar.push(mar10);
priceArrayMar.push(mar11);
priceArrayMar.push(mar12);
priceArrayMar.push(mar13);
priceArrayMar.push(mar14);
priceArrayMar.push(mar15);
priceArrayMar.push(mar16);
priceArrayMar.push(mar17);
priceArrayMar.push(mar18);
priceArrayMar.push(mar19);
priceArrayMar.push(mar20);
priceArrayMar.push(mar21);
priceArrayMar.push(mar22);
priceArrayMar.push(mar23);
priceArrayMar.push(mar24);
priceArrayMar.push(mar25);
priceArrayMar.push(mar26);
priceArrayMar.push(mar27);
priceArrayMar.push(mar28);
priceArrayMar.push(mar29);
priceArrayMar.push(mar30);
priceArrayMar.push(mar31);

priceArrayApr.push(apr1);
priceArrayApr.push(apr2);
priceArrayApr.push(apr3);
priceArrayApr.push(apr4);
priceArrayApr.push(apr5);
priceArrayApr.push(apr6);
priceArrayApr.push(apr7);
priceArrayApr.push(apr8);
priceArrayApr.push(apr9);
priceArrayApr.push(apr10);
priceArrayApr.push(apr11);
priceArrayApr.push(apr12);
priceArrayApr.push(apr13);
priceArrayApr.push(apr14);
priceArrayApr.push(apr15);
priceArrayApr.push(apr16);
priceArrayApr.push(apr17);
priceArrayApr.push(apr18);
priceArrayApr.push(apr19);
priceArrayApr.push(apr20);
priceArrayApr.push(apr21);
priceArrayApr.push(apr22);
priceArrayApr.push(apr23);
priceArrayApr.push(apr24);
priceArrayApr.push(apr25);
priceArrayApr.push(apr26);
priceArrayApr.push(apr27);
priceArrayApr.push(apr28);
priceArrayApr.push(apr29);
priceArrayApr.push(apr30);

priceArrayMay.push(may1);
priceArrayMay.push(may2);
priceArrayMay.push(may3);
priceArrayMay.push(may4);
priceArrayMay.push(may5);
priceArrayMay.push(may6);
priceArrayMay.push(may7);
priceArrayMay.push(may8);
priceArrayMay.push(may9);
priceArrayMay.push(may10);
priceArrayMay.push(may11);
priceArrayMay.push(may12);
priceArrayMay.push(may13);
priceArrayMay.push(may14);
priceArrayMay.push(may15);
priceArrayMay.push(may16);
priceArrayMay.push(may17);
priceArrayMay.push(may18);
priceArrayMay.push(may19);
priceArrayMay.push(may20);
priceArrayMay.push(may21);
priceArrayMay.push(may22);
priceArrayMay.push(may23);
priceArrayMay.push(may24);
priceArrayMay.push(may25);
priceArrayMay.push(may26);
priceArrayMay.push(may27);
priceArrayMay.push(may28);
priceArrayMay.push(may29);
priceArrayMay.push(may30);
priceArrayMay.push(may31);

priceArrayJun.push(jun1);
priceArrayJun.push(jun2);
priceArrayJun.push(jun3);
priceArrayJun.push(jun4);
priceArrayJun.push(jun5);
priceArrayJun.push(jun6);
priceArrayJun.push(jun7);
priceArrayJun.push(jun8);
priceArrayJun.push(jun9);
priceArrayJun.push(jun10);
priceArrayJun.push(jun11);
priceArrayJun.push(jun12);
priceArrayJun.push(jun13);
priceArrayJun.push(jun14);
priceArrayJun.push(jun15);
priceArrayJun.push(jun16);
priceArrayJun.push(jun17);
priceArrayJun.push(jun18);
priceArrayJun.push(jun19);
priceArrayJun.push(jun20);
priceArrayJun.push(jun21);
priceArrayJun.push(jun22);
priceArrayJun.push(jun23);
priceArrayJun.push(jun24);
priceArrayJun.push(jun25);
priceArrayJun.push(jun26);
priceArrayJun.push(jun27);
priceArrayJun.push(jun28);
priceArrayJun.push(jun29);
priceArrayJun.push(jun30);


priceArrayJul.push(jul1);
priceArrayJul.push(jul2);
priceArrayJul.push(jul3);
priceArrayJul.push(jul4);
priceArrayJul.push(jul5);
priceArrayJul.push(jul6);
priceArrayJul.push(jul7);
priceArrayJul.push(jul8);
priceArrayJul.push(jul9);
priceArrayJul.push(jul10);
priceArrayJul.push(jul11);
priceArrayJul.push(jul12);
priceArrayJul.push(jul13);
priceArrayJul.push(jul14);
priceArrayJul.push(jul15);
priceArrayJul.push(jul16);
priceArrayJul.push(jul17);
priceArrayJul.push(jul18);
priceArrayJul.push(jul19);
priceArrayJul.push(jul20);
priceArrayJul.push(jul21);
priceArrayJul.push(jul22);
priceArrayJul.push(jul23);
priceArrayJul.push(jul24);
priceArrayJul.push(jul25);
priceArrayJul.push(jul26);
priceArrayJul.push(jul27);
priceArrayJul.push(jul28);
priceArrayJul.push(jul29);
priceArrayJul.push(jul30);
priceArrayJul.push(jul31);

priceArrayAug.push(aug1);
priceArrayAug.push(aug2);
priceArrayAug.push(aug3);
priceArrayAug.push(aug4);
priceArrayAug.push(aug5);
priceArrayAug.push(aug6);
priceArrayAug.push(aug7);
priceArrayAug.push(aug8);
priceArrayAug.push(aug9);
priceArrayAug.push(aug10);
priceArrayAug.push(aug11);
priceArrayAug.push(aug12);
priceArrayAug.push(aug13);
priceArrayAug.push(aug14);
priceArrayAug.push(aug15);
priceArrayAug.push(aug16);
priceArrayAug.push(aug17);
priceArrayAug.push(aug18);
priceArrayAug.push(aug19);
priceArrayAug.push(aug20);
priceArrayAug.push(aug21);
priceArrayAug.push(aug22);
priceArrayAug.push(aug23);
priceArrayAug.push(aug24);
priceArrayAug.push(aug25);
priceArrayAug.push(aug26);
priceArrayAug.push(aug27);
priceArrayAug.push(aug28);
priceArrayAug.push(aug29);
priceArrayAug.push(aug30);
priceArrayAug.push(aug31);

priceArraySep.push(sep1);
priceArraySep.push(sep2);
priceArraySep.push(sep3);
priceArraySep.push(sep4);
priceArraySep.push(sep5);
priceArraySep.push(sep6);
priceArraySep.push(sep7);
priceArraySep.push(sep8);
priceArraySep.push(sep9);
priceArraySep.push(sep10);
priceArraySep.push(sep11);
priceArraySep.push(sep12);
priceArraySep.push(sep13);
priceArraySep.push(sep14);
priceArraySep.push(sep15);
priceArraySep.push(sep16);
priceArraySep.push(sep17);
priceArraySep.push(sep18);
priceArraySep.push(sep19);
priceArraySep.push(sep20);
priceArraySep.push(sep21);
priceArraySep.push(sep22);
priceArraySep.push(sep23);
priceArraySep.push(sep24);
priceArraySep.push(sep25);
priceArraySep.push(sep26);
priceArraySep.push(sep27);
priceArraySep.push(sep28);
priceArraySep.push(sep29);
priceArraySep.push(sep30);


priceArrayOct.push(oct1);
priceArrayOct.push(oct2);
priceArrayOct.push(oct3);
priceArrayOct.push(oct4);
priceArrayOct.push(oct5);
priceArrayOct.push(oct6);
priceArrayOct.push(oct7);
priceArrayOct.push(oct8);
priceArrayOct.push(oct9);
priceArrayOct.push(oct10);
priceArrayOct.push(oct11);
priceArrayOct.push(oct12);
priceArrayOct.push(oct13);
priceArrayOct.push(oct14);
priceArrayOct.push(oct15);
priceArrayOct.push(oct16);
priceArrayOct.push(oct17);
priceArrayOct.push(oct18);
priceArrayOct.push(oct19);
priceArrayOct.push(oct20);
priceArrayOct.push(oct21);
priceArrayOct.push(oct22);
priceArrayOct.push(oct23);
priceArrayOct.push(oct24);
priceArrayOct.push(oct25);
priceArrayOct.push(oct26);
priceArrayOct.push(oct27);
priceArrayOct.push(oct28);
priceArrayOct.push(oct29);
priceArrayOct.push(oct30);
priceArrayOct.push(oct31);

priceArrayNov.push(nov1);
priceArrayNov.push(nov2);
priceArrayNov.push(nov3);
priceArrayNov.push(nov4);
priceArrayNov.push(nov5);
priceArrayNov.push(nov6);
priceArrayNov.push(nov7);
priceArrayNov.push(nov8);
priceArrayNov.push(nov9);
priceArrayNov.push(nov10);
priceArrayNov.push(nov11);
priceArrayNov.push(nov12);
priceArrayNov.push(nov13);
priceArrayNov.push(nov14);
priceArrayNov.push(nov15);
priceArrayNov.push(nov16);
priceArrayNov.push(nov17);
priceArrayNov.push(nov18);
priceArrayNov.push(nov19);
priceArrayNov.push(nov20);
priceArrayNov.push(nov21);
priceArrayNov.push(nov22);
priceArrayNov.push(nov23);
priceArrayNov.push(nov24);
priceArrayNov.push(nov25);
priceArrayNov.push(nov26);
priceArrayNov.push(nov27);
priceArrayNov.push(nov28);
priceArrayNov.push(nov29);
priceArrayNov.push(nov30);

priceArrayDec.push(dec1);
priceArrayDec.push(dec2);
priceArrayDec.push(dec3);
priceArrayDec.push(dec4);
priceArrayDec.push(dec5);
priceArrayDec.push(dec6);
priceArrayDec.push(dec7);
priceArrayDec.push(dec8);
priceArrayDec.push(dec9);
priceArrayDec.push(dec10);
priceArrayDec.push(dec11);
priceArrayDec.push(dec12);
priceArrayDec.push(dec13);
priceArrayDec.push(dec14);
priceArrayDec.push(dec15);
priceArrayDec.push(dec16);
priceArrayDec.push(dec17);
priceArrayDec.push(dec18);
priceArrayDec.push(dec19);
priceArrayDec.push(dec20);
priceArrayDec.push(dec21);
priceArrayDec.push(dec22);
priceArrayDec.push(dec23);
priceArrayDec.push(dec24);
priceArrayDec.push(dec25);
priceArrayDec.push(dec26);
priceArrayDec.push(dec27);
priceArrayDec.push(dec28);
priceArrayDec.push(dec29);
priceArrayDec.push(dec30);
priceArrayDec.push(dec31);


var janTotal = 0;
var febTotal = 0;
var marTotal = 0;
var aprTotal = 0;
var mayTotal = 0;
var junTotal = 0;
var julTotal = 0;
var augTotal = 0;
var sepTotal = 0;
var octTotal = 0;
var novTotal = 0;
var decTotal = 0;

for (var i = 0; i < priceArrayJan.length; i++) {
	janTotal+= priceArrayJan[i];
}

for (var i = 0; i < priceArrayFeb.length; i++) {
	febTotal+= priceArrayFeb[i];
}

for (var i = 0; i < priceArrayMar.length; i++) {
	marTotal+= priceArrayMar[i];
}

for (var i = 0; i < priceArrayApr.length; i++) {
	aprTotal+= priceArrayApr[i];
}

for (var i = 0; i < priceArrayMay.length; i++) {
	mayTotal+= priceArrayMay[i];
}

for (var i = 0; i < priceArrayJun.length; i++) {
	junTotal+= priceArrayJun[i];
}

for (var i = 0; i < priceArrayJul.length; i++) {
	julTotal+= priceArrayJul[i];
}

for (var i = 0; i < priceArrayAug.length; i++) {
	augTotal+= priceArrayAug[i];
}

for (var i = 0; i < priceArraySep.length; i++) {
	sepTotal+= priceArraySep[i];
}

for (var i = 0; i < priceArrayOct.length; i++) {
	octTotal+= priceArrayOct[i];
}

for (var i = 0; i < priceArrayNov.length; i++) {
	novTotal+= priceArrayNov[i];
}

for (var i = 0; i < priceArrayDec.length; i++) {
	decTotal+= priceArrayDec[i];
}

thisYearPriceArray = [janTotal, febTotal, marTotal, aprTotal, mayTotal, junTotal, julTotal, augTotal, sepTotal, octTotal, novTotal, decTotal];


function thisYearSpendButtonClicked() {
	
	document.querySelector(".chart-label-x").textContent = "Months";
    var graphDataArray = [];
    for (var i = 0; i < thisYearPriceArray.length; i++) {
        graphDataArray.push({ "y": thisYearPriceArray[i] });
    }
    var chart = new CanvasJS.Chart("chartContainer", {
        animationEnabled: true,
        theme: "light4",
        title: {
            text: "Euros Spent This Year"
        },
        data: [{
        	type: "line",
            lineColor: "black",
            markerColor: "black",
            indexLabelFontSize: 16,
            dataPoints: graphDataArray
        }]
    });
    chart.render();
	
}

var today = new Date();
var mm = today.getMonth()+1; //As January is 0.


window.onload = function () {
	
	if (mm == 1){

		document.querySelector(".header-picture").style.background = 'url(images/jan-picture.jpeg)';
		document.querySelector(".header-text").style.background = '#0775d3';
		document.querySelector("#header").style.backgroundColor = "#0775d3";
		document.querySelector(".add-food-item-button").style.backgroundColor = "##0775d3";
		document.querySelector(".footer").style.backgroundColor = "#0775d3";
		
		var changeTableHeadingsColor = document.querySelector("tr").getElementsByTagName("th");

		for(var i=0;i<changeTableHeadingsColor.length;i++){
			changeTableHeadingsColor[i].style.background = "#0775d3"   
		}
		
	    var graphDataArray = [];
	    for (var i = 0; i < priceArrayJan.length; i++) {
	        graphDataArray.push({ "y": priceArrayJan[i] });
	    }
	    var chart = new CanvasJS.Chart("chartContainer", {
	        animationEnabled: true,
	        theme: "light4",
	        title: {
	            text: "Euros Spent January"
	        },
	        data: [{
	        	type: "line",
	            lineColor: "black",
	            markerColor: "black",
	            indexLabelFontSize: 16,
	            dataPoints: graphDataArray
	        }]
	    });
	    chart.render();

	}
	
	if (mm == 2){
		document.querySelector(".header-picture").style.background = 'url(images/vegtables.jpg)';
		document.querySelector(".header-text").style.background = '#0775d3';
		document.querySelector("#header").style.backgroundColor = "#0775d3";
		document.querySelector(".add-food-item-button").style.backgroundColor = "#0775d3";
		document.querySelector(".footer").style.backgroundColor = "#0775d3";
		var changeTableHeadingsColor = document.querySelector("tr").getElementsByTagName("th");

		for(var i=0;i<changeTableHeadingsColor.length;i++){
			changeTableHeadingsColor[i].style.background = "#0775d3"   
		}
		
	    var graphDataArray = [];
	    for (var i = 0; i < priceArrayFeb.length; i++) {
	        graphDataArray.push({ "y": priceArrayFeb[i] });
	    }
	    var chart = new CanvasJS.Chart("chartContainer", {
	        animationEnabled: true,
	        theme: "light4",
	        title: {
	            text: "Euros Spent February"
	        },
	        data: [{
	            type: "line",
	            lineColor: "black",
	            markerColor: "black",
	            indexLabelFontSize: 16,
	            dataPoints: graphDataArray
	        }]
	    });
	    chart.render();
	}
	
	if (mm == 3){
		
		document.querySelector(".header-picture").style.background = 'url(images/vegtables.jpg)';
		document.querySelector(".header-text").style.background = '#f830ff';
		document.querySelector("#header").style.backgroundColor = "#f830ff";
		document.querySelector(".add-food-item-button").style.backgroundColor = "#f830ff";
		document.querySelector(".footer").style.backgroundColor = "#f830ff";
		
		var changeTableHeadingsColor = document.querySelector("tr").getElementsByTagName("th");

		for(var i=0;i<changeTableHeadingsColor.length;i++){
			changeTableHeadingsColor[i].style.background = "#f830ff"   
		}
		
	    var graphDataArray = [];
	    for (var i = 0; i < priceArrayMar.length; i++) {
	        graphDataArray.push({ "y": priceArrayMar[i] });
	    }
	    var chart = new CanvasJS.Chart("chartContainer", {
	        animationEnabled: true,
	        theme: "light2",
	        title: {
	            text: "Euros Spent March"
	        },
	        data: [{
	            type: "line",
	            indexLabelFontSize: 16,
	            dataPoints: graphDataArray
	        }]
	    });
	    chart.render();
		
	}
	
	if (mm == 4){
		document.querySelector(".header-picture").style.background = 'url(images/easter-eggs.jpg)';
		document.querySelector(".header-text").style.background = '#f830ff';
		document.querySelector("#header").style.backgroundColor = "#f830ff";
		document.querySelector(".add-food-item-button").style.backgroundColor = "#f830ff";
		document.querySelector(".footer").style.backgroundColor = "#f830ff";
		
		var changeTableHeadingsColor = document.querySelector("tr").getElementsByTagName("th");

		for(var i=0;i<changeTableHeadingsColor.length;i++){
			changeTableHeadingsColor[i].style.background = "#f830ff"   
		}
		
	    var graphDataArray = [];
	    for (var i = 0; i < priceArrayApr.length; i++) {
	        graphDataArray.push({ "y": priceArrayApr[i] });
	    }
	    var chart = new CanvasJS.Chart("chartContainer", {
	        animationEnabled: true,
	        theme: "light2",
	        title: {
	            text: "Euros Spent April"
	        },
	        data: [{
	            type: "line",
	            indexLabelFontSize: 16,
	            dataPoints: graphDataArray
	        }]
	    });
	    chart.render();
		
	}
	
	if (mm == 5){
		
		document.querySelector(".header-picture").style.background = 'url(images/vegtables.jpg)';
		document.querySelector(".header-text").style.background = '#f830ff';
		document.querySelector("#header").style.backgroundColor = "#f830ff";
		document.querySelector(".add-food-item-button").style.backgroundColor = "#f830ff";
		document.querySelector(".footer").style.backgroundColor = "#f830ff";
		
		var changeTableHeadingsColor = document.querySelector("tr").getElementsByTagName("th");

		for(var i=0;i<changeTableHeadingsColor.length;i++){
			changeTableHeadingsColor[i].style.background = "#f830ff"   
		}
		
	    var graphDataArray = [];
	    for (var i = 0; i < priceArrayMay.length; i++) {
	        graphDataArray.push({ "y": priceArrayMay[i] });
	    }
	    var chart = new CanvasJS.Chart("chartContainer", {
	        animationEnabled: true,
	        theme: "light2",
	        title: {
	            text: "Euros Spent May"
	        },
	        data: [{
	            type: "line",
	            indexLabelFontSize: 16,
	            dataPoints: graphDataArray
	        }]
	    });
	    chart.render();
		
	}
	
	if (mm == 6){
		
		document.querySelector(".header-picture").style.background = 'url(images/berries.jpg)';
		document.querySelector(".header-text").style.background = '#fc7521';
		document.querySelector("#header").style.backgroundColor = "#fc7521";
		document.querySelector(".add-food-item-button").style.backgroundColor = "#fc7521";
		document.querySelector(".footer").style.backgroundColor = "#fc7521";
		
		var changeTableHeadingsColor = document.querySelector("tr").getElementsByTagName("th");

		for(var i=0;i<changeTableHeadingsColor.length;i++){
			changeTableHeadingsColor[i].style.background = "#fc7521"   
		}
		
	    var graphDataArray = [];
	    for (var i = 0; i < priceArrayJun.length; i++) {
	        graphDataArray.push({ "y": priceArrayJun[i] });
	    }
	    var chart = new CanvasJS.Chart("chartContainer", {
	        animationEnabled: true,
	        theme: "light2",
	        title: {
	            text: "Euros Spent June"
	        },
	        data: [{
	            type: "line",
	            indexLabelFontSize: 16,
	            dataPoints: graphDataArray
	        }]
	    });
	    chart.render();
		
	}
	
	if (mm == 7){

		document.querySelector(".header-picture").style.background = 'url(images/berries.jpg)';
		document.querySelector(".header-text").style.background = '#fc7521';
		document.querySelector("#header").style.backgroundColor = "#fc7521";
		document.querySelector(".add-food-item-button").style.backgroundColor = "#fc7521";
		document.querySelector(".footer").style.backgroundColor = "#fc7521";
		
		var changeTableHeadingsColor = document.querySelector("tr").getElementsByTagName("th");

		for(var i=0;i<changeTableHeadingsColor.length;i++){
			changeTableHeadingsColor[i].style.background = "#fc7521"   
		}
		
	    var graphDataArray = [];
	    for (var i = 0; i < priceArrayJul.length; i++) {
	        graphDataArray.push({ "y": priceArrayJul[i] });
	    }
	    var chart = new CanvasJS.Chart("chartContainer", {
	        animationEnabled: true,
	        theme: "light2",
	        title: {
	            text: "Euros Spent July"
	        },
	        data: [{
	            type: "line",
	            indexLabelFontSize: 16,
	            dataPoints: graphDataArray
	        }]
	    });
	    chart.render();
		
	}
	
	if (mm == 8){
		
		document.querySelector(".header-picture").style.background = 'url(images/berries.jpg)';
		document.querySelector(".header-text").style.background = '#fc7521';
		document.querySelector("#header").style.backgroundColor = "#fc7521";
		document.querySelector(".add-food-item-button").style.backgroundColor = "#fc7521";
		document.querySelector(".footer").style.backgroundColor = "#fc7521";
		
		var changeTableHeadingsColor = document.querySelector("tr").getElementsByTagName("th");

		for(var i=0;i<changeTableHeadingsColor.length;i++){
			changeTableHeadingsColor[i].style.background = "#fc7521"   
		}
		
	    var graphDataArray = [];
	    for (var i = 0; i < priceArrayAug.length; i++) {
	        graphDataArray.push({ "y": priceArrayAug[i] });
	    }
	    var chart = new CanvasJS.Chart("chartContainer", {
	        animationEnabled: true,
	        theme: "light2",
	        title: {
	            text: "Euros Spent August"
	        },
	        data: [{
	            type: "line",
	            indexLabelFontSize: 16,
	            dataPoints: graphDataArray
	        }]
	    });
	    chart.render();
		
	}
	
	if (mm == 9){
		
		document.querySelector(".header-picture").style.background = 'url(images/berries.jpg)';
		document.querySelector(".header-text").style.background = '#fc7521';
		document.querySelector("#header").style.backgroundColor = "#fc7521";
		document.querySelector(".add-food-item-button").style.backgroundColor = "#fc7521";
		document.querySelector(".footer").style.backgroundColor = "#fc7521";
		
		var changeTableHeadingsColor = document.querySelector("tr").getElementsByTagName("th");

		for(var i=0;i<changeTableHeadingsColor.length;i++){
			changeTableHeadingsColor[i].style.background = "#fc7521"   
		}
		
	    var graphDataArray = [];
	    for (var i = 0; i < priceArraySep.length; i++) {
	        graphDataArray.push({ "y": priceArraySep[i] });
	    }
	    var chart = new CanvasJS.Chart("chartContainer", {
	        animationEnabled: true,
	        theme: "light2",
	        title: {
	            text: "Euros Spent September"
	        },
	        data: [{
	            type: "line",
	            indexLabelFontSize: 16,
	            dataPoints: graphDataArray
	        }]
	    });
	    chart.render();
		
	}
	
	if (mm == 10){
		document.querySelector(".header-picture").style.background = 'url(images/pumpkins.jpg)';
		document.querySelector(".header-text").style.background = '#b86004';
		document.querySelector(".header-text").style.background = '#b86004';
		document.querySelector("#header").style.backgroundColor = "#b86004";
		document.querySelector(".add-food-item-button").style.backgroundColor = "#b86004";
		document.querySelector(".footer").style.backgroundColor = "#b86004";
		
		var changeTableHeadingsColor = document.querySelector("tr").getElementsByTagName("th");

		for(var i=0;i<changeTableHeadingsColor.length;i++){
			changeTableHeadingsColor[i].style.background = "#b86004"   
		}
		
	    var graphDataArray = [];
	    for (var i = 0; i < priceArrayOct.length; i++) {
	        graphDataArray.push({ "y": priceArrayOct[i] });
	    }
	    var chart = new CanvasJS.Chart("chartContainer", {
	        animationEnabled: true,
	        theme: "light2",
	        title: {
	            text: "Euros Spent October"
	        },
	        data: [{
	            type: "line",
	            indexLabelFontSize: 16,
	            dataPoints: graphDataArray
	        }]
	    });
	    chart.render();
		
	}
	
	if (mm == 11){
		
		document.querySelector(".header-picture").style.background = 'url(images/pumpkins.jpg)';
		document.querySelector(".header-text").style.background = '#b86004';
		document.querySelector("#header").style.backgroundColor = "#b86004";
		document.querySelector(".add-food-item-button").style.backgroundColor = "#b86004";
		document.querySelector(".footer").style.backgroundColor = "#b86004";
		
		var changeTableHeadingsColor = document.querySelector("tr").getElementsByTagName("th");

		for(var i=0;i<changeTableHeadingsColor.length;i++){
			changeTableHeadingsColor[i].style.background = "#b86004"   
		}
		
	    var graphDataArray = [];
	    for (var i = 0; i < priceArrayNov.length; i++) {
	        graphDataArray.push({ "y": priceArrayNov[i] });
	    }
	    var chart = new CanvasJS.Chart("chartContainer", {
	        animationEnabled: true,
	        theme: "light2",
	        title: {
	            text: "Euros Spent November"
	        },
	        data: [{
	            type: "line",
	            indexLabelFontSize: 16,
	            dataPoints: graphDataArray
	        }]
	    });
	    chart.render();
		
	}
	
	if (mm == 12){

		document.querySelector(".header-picture").style.background = 'url(images/christmas-dinner.jpg)';
		document.querySelector(".header-text").style.background = '#eb1010';
		document.querySelector("#header").style.backgroundColor = "#008204";
		document.querySelector(".add-food-item-button").style.backgroundColor = "#008204";
		document.querySelector(".footer").style.backgroundColor = "#eb1010";
		var changeTableHeadingsColor = document.querySelector("tr").getElementsByTagName("th");

		for(var i=0;i<changeTableHeadingsColor.length;i++){
			changeTableHeadingsColor[i].style.background = "#eb1010"   
		}
		
		var changeTableHeadingsColor = document.querySelector("tr").getElementsByTagName("th");

		for(var i=0;i<changeTableHeadingsColor.length;i++){
			changeTableHeadingsColor[i].style.background = "#f830ff"   
		}
		
	    var graphDataArray = [];
	    for (var i = 0; i < priceArrayDec.length; i++) {
	        graphDataArray.push({ "y": priceArrayDec[i] });
	    }
	    var chart = new CanvasJS.Chart("chartContainer", {
	        animationEnabled: true,
	        theme: "light2",
	        title: {
	            text: "Euros Spent December"
	        },
	        data: [{
	            type: "line",
	            indexLabelFontSize: 16,
	            dataPoints: graphDataArray
	        }]
	    });
	    chart.render();
		
	}	
}

function lastMonthSpendButtonClicked() {
	
	document.querySelector(".chart-label-x").textContent = "Days";
	
	if (mm == 0) {
		mm = 12;
	}

	if (mm == 1) {
    var graphDataArray = [];
    for (var i = 0; i < priceArrayJan.length; i++) {
        graphDataArray.push({ "y": priceArrayJan[i] });
    }
    var chart = new CanvasJS.Chart("chartContainer", {
        animationEnabled: true,
        theme: "light4",
        title: {
            text: "Euros Spent January"
        },
        data: [{
        	type: "line",
            lineColor: "black",
            markerColor: "black",
            indexLabelFontSize: 16,
            dataPoints: graphDataArray
        }]
    });
    chart.render();
    
	}
	
	if (mm == 2) {
		
		document.querySelector(".chart-label-x").textContent = "Days";
	    var graphDataArray = [];
	    for (var i = 0; i < priceArrayFeb.length; i++) {
	        graphDataArray.push({ "y": priceArrayFeb[i] });
	    }
	    var chart = new CanvasJS.Chart("chartContainer", {
	        animationEnabled: true,
	        theme: "light4",
	        title: {
	            text: "Euros Spent February"
	        },
	        data: [{
	        	type: "line",
	            lineColor: "black",
	            markerColor: "black",
	            indexLabelFontSize: 16,
	            dataPoints: graphDataArray
	        }]
	    });
	    chart.render();
	    
		}
	
if (mm == 3) {
	
	document.querySelector(".chart-label-x").textContent = "Days";
    var graphDataArray = [];
    for (var i = 0; i < priceArrayMar.length; i++) {
        graphDataArray.push({ "y": priceArrayMar[i] });
    }
    var chart = new CanvasJS.Chart("chartContainer", {
        animationEnabled: true,
        theme: "light4",
        title: {
            text: "Euros Spent March"
        },
        data: [{
        	type: "line",
            lineColor: "black",
            markerColor: "black",
            indexLabelFontSize: 16,
            dataPoints: graphDataArray
        }]
    });
    chart.render();
    
	}

if (mm == 4) {
	
	document.querySelector(".chart-label-x").textContent = "Days";
    var graphDataArray = [];
    for (var i = 0; i < priceArrayApr.length; i++) {
        graphDataArray.push({ "y": priceArrayApr[i] });
    }
    var chart = new CanvasJS.Chart("chartContainer", {
        animationEnabled: true,
        theme: "light4",
        title: {
            text: "Euros Spent April"
        },
        data: [{
        	type: "line",
            lineColor: "black",
            markerColor: "black",
            indexLabelFontSize: 16,
            dataPoints: graphDataArray
        }]
    });
    chart.render();
    
	}

if (mm == 5) {
	
	document.querySelector(".chart-label-x").textContent = "Days";
    var graphDataArray = [];
    for (var i = 0; i < priceArrayMay.length; i++) {
        graphDataArray.push({ "y": priceArrayMay[i] });
    }
    var chart = new CanvasJS.Chart("chartContainer", {
        animationEnabled: true,
        theme: "light4",
        title: {
            text: "Euros Spent May"
        },
        data: [{
        	type: "line",
            lineColor: "black",
            markerColor: "black",
            indexLabelFontSize: 16,
            dataPoints: graphDataArray
        }]
    });
    chart.render();
    
	}

if (mm == 6) {
	
	document.querySelector(".chart-label-x").textContent = "Days";
    var graphDataArray = [];
    for (var i = 0; i < priceArrayJun.length; i++) {
        graphDataArray.push({ "y": priceArrayJun[i] });
    }
    var chart = new CanvasJS.Chart("chartContainer", {
        animationEnabled: true,
        theme: "light4",
        title: {
            text: "Euros Spent June"
        },
        data: [{
        	type: "line",
            lineColor: "black",
            markerColor: "black",
            indexLabelFontSize: 16,
            dataPoints: graphDataArray
        }]
    });
    chart.render();
    
	}

if (mm == 7) {
	
	document.querySelector(".chart-label-x").textContent = "Days";
    var graphDataArray = [];
    for (var i = 0; i < priceArrayJul.length; i++) {
        graphDataArray.push({ "y": priceArrayJul[i] });
    }
    var chart = new CanvasJS.Chart("chartContainer", {
        animationEnabled: true,
        theme: "light4",
        title: {
            text: "Euros Spent July"
        },
        data: [{
        	type: "line",
            lineColor: "black",
            markerColor: "black",
            indexLabelFontSize: 16,
            dataPoints: graphDataArray
        }]
    });
    chart.render();
    
	}

if (mm == 8) {
	
	document.querySelector(".chart-label-x").textContent = "Days";
    var graphDataArray = [];
    for (var i = 0; i < priceArrayAug.length; i++) {
        graphDataArray.push({ "y": priceArrayAug[i] });
    }
    var chart = new CanvasJS.Chart("chartContainer", {
        animationEnabled: true,
        theme: "light4",
        title: {
            text: "Euros Spent August"
        },
        data: [{
        	type: "line",
            lineColor: "black",
            markerColor: "black",
            indexLabelFontSize: 16,
            dataPoints: graphDataArray
        }]
    });
    chart.render();
    
	}

if (mm == 9) {
	
	document.querySelector(".chart-label-x").textContent = "Days";
    var graphDataArray = [];
    for (var i = 0; i < priceArraySep.length; i++) {
        graphDataArray.push({ "y": priceArraySep[i] });
    }
    var chart = new CanvasJS.Chart("chartContainer", {
        animationEnabled: true,
        theme: "light4",
        title: {
            text: "Euros Spent September"
        },
        data: [{
        	type: "line",
            lineColor: "black",
            markerColor: "black",
            indexLabelFontSize: 16,
            dataPoints: graphDataArray
        }]
    });
    chart.render();
    
	}

if (mm == 10) {
	
	document.querySelector(".chart-label-x").textContent = "Days";
    var graphDataArray = [];
    for (var i = 0; i < priceArrayOct.length; i++) {
        graphDataArray.push({ "y": priceArrayOct[i] });
    }
    var chart = new CanvasJS.Chart("chartContainer", {
        animationEnabled: true,
        theme: "light4",
        title: {
            text: "Euros Spent October"
        },
        data: [{
        	type: "line",
            lineColor: "black",
            markerColor: "black",
            indexLabelFontSize: 16,
            dataPoints: graphDataArray
        }]
    });
    chart.render();
    
	}

if (mm == 11) {
	
	document.querySelector(".chart-label-x").textContent = "Days";
    var graphDataArray = [];
    for (var i = 0; i < priceArrayNov.length; i++) {
        graphDataArray.push({ "y": priceArrayNov[i] });
    }
    var chart = new CanvasJS.Chart("chartContainer", {
        animationEnabled: true,
        theme: "light4",
        title: {
            text: "Euros Spent November"
        },
        data: [{
        	type: "line",
            lineColor: "black",
            markerColor: "black",
            indexLabelFontSize: 16,
            dataPoints: graphDataArray
        }]
    });
    chart.render();
    
	}

if (mm == 12) {
	
	document.querySelector(".chart-label-x").textContent = "Days";
    var graphDataArray = [];
    for (var i = 0; i < priceArrayDec.length; i++) {
        graphDataArray.push({ "y": priceArrayDec[i] });
    }
    var chart = new CanvasJS.Chart("chartContainer", {
        animationEnabled: true,
        theme: "light4",
        title: {
            text: "Euros Spent December"
        },
        data: [{
        	type: "line",
            lineColor: "black",
            markerColor: "black",
            indexLabelFontSize: 16,
            dataPoints: graphDataArray
        }]
    });
    chart.render();
    
	}
}

////////////////////////Wasted Items//////////////////////////////////

var jan1Waste = 0;
var jan2Waste = 0;
var jan3Waste = 0;
var jan4Waste = 0;
var jan5Waste = 0;
var jan6Waste = 0;
var jan7Waste = 0;
var jan8Waste = 0;
var jan9Waste = 0;
var jan10Waste = 0;
var jan11Waste = 0;
var jan12Waste = 0;
var jan13Waste = 0;
var jan14Waste = 0;
var jan15Waste = 0;
var jan16Waste = 0;
var jan17Waste = 0;
var jan18Waste = 0;
var jan19Waste = 0;
var jan20Waste = 0;
var jan21Waste = 0;
var jan22Waste = 0;
var jan23Waste = 0;
var jan24Waste = 0;
var jan25Waste = 0;
var jan26Waste = 0;
var jan27Waste = 0;
var jan28Waste = 0;
var jan29Waste = 0;
var jan30Waste = 0;
var jan31Waste = 0;

var feb1Waste = 0;
var feb2Waste = 0;
var feb3Waste = 0;
var feb4Waste = 0;
var feb5Waste = 0;
var feb6Waste = 0;
var feb7Waste = 0;
var feb8Waste = 0;
var feb9Waste = 0;
var feb10Waste = 0;
var feb11Waste = 0;
var feb12Waste = 0;
var feb13Waste = 0;
var feb14Waste = 0;
var feb15Waste = 0;
var feb16Waste = 0;
var feb17Waste = 0;
var feb18Waste = 0;
var feb19Waste = 0;
var feb20Waste = 0;
var feb21Waste = 0;
var feb22Waste = 0;
var feb23Waste = 0;
var feb24Waste = 0;
var feb25Waste = 0;
var feb26Waste = 0;
var feb27Waste = 0;
var feb28Waste = 0;

var mar1Waste = 0;
var mar2Waste = 0;
var mar3Waste = 0;
var mar4Waste = 0;
var mar5Waste = 0;
var mar6Waste = 0;
var mar7Waste = 0;
var mar8Waste = 0;
var mar9Waste = 0;
var mar10Waste = 0;
var mar11Waste = 0;
var mar12Waste = 0;
var mar13Waste = 0;
var mar14Waste = 0;
var mar15Waste = 0;
var mar16Waste = 0;
var mar17Waste = 0;
var mar18Waste = 0;
var mar19Waste = 0;
var mar20Waste = 0;
var mar21Waste = 0;
var mar22Waste = 0;
var mar23Waste = 0;
var mar24Waste = 0;
var mar25Waste = 0;
var mar26Waste = 0;
var mar27Waste = 0;
var mar28Waste = 0;
var mar29Waste = 0;
var mar30Waste = 0;
var mar31Waste = 0;

var apr1Waste = 0;
var apr2Waste = 0;
var apr3Waste = 0;
var apr4Waste = 0;
var apr5Waste = 0;
var apr6Waste = 0;
var apr7Waste = 0;
var apr8Waste = 0;
var apr9Waste = 0;
var apr10Waste = 0;
var apr11Waste = 0;
var apr12Waste = 0;
var apr13Waste = 0;
var apr14Waste = 0;
var apr15Waste = 0;
var apr16Waste = 0;
var apr17Waste = 0;
var apr18Waste = 0;
var apr19Waste = 0;
var apr20Waste = 0;
var apr21Waste = 0;
var apr22Waste = 0;
var apr23Waste = 0;
var apr24Waste = 0;
var apr25Waste = 0;
var apr26Waste = 0;
var apr27Waste = 0;
var apr28Waste = 0;
var apr29Waste = 0;
var apr30Waste = 0;

var may1Waste = 0;
var may2Waste = 0;
var may3Waste = 0;
var may4Waste = 0;
var may5Waste = 0;
var may6Waste = 0;
var may7Waste = 0;
var may8Waste = 0;
var may9Waste = 0;
var may10Waste = 0;
var may11Waste = 0;
var may12Waste = 0;
var may13Waste = 0;
var may14Waste = 0;
var may15Waste = 0;
var may16Waste = 0;
var may17Waste = 0;
var may18Waste = 0;
var may19Waste = 0;
var may20Waste = 0;
var may21Waste = 0;
var may22Waste = 0;
var may23Waste = 0;
var may24Waste = 0;
var may25Waste = 0;
var may26Waste = 0;
var may27Waste = 0;
var may28Waste = 0;
var may29Waste = 0;
var may30Waste = 0;
var may31Waste = 0;

var jun1Waste = 0;
var jun2Waste = 0;
var jun3Waste = 0;
var jun4Waste = 0;
var jun5Waste = 0;
var jun6Waste = 0;
var jun7Waste = 0;
var jun8Waste = 0;
var jun9Waste = 0;
var jun10Waste = 0;
var jun11Waste = 0;
var jun12Waste = 0;
var jun13Waste = 0;
var jun14Waste = 0;
var jun15Waste = 0;
var jun16Waste = 0;
var jun17Waste = 0;
var jun18Waste = 0;
var jun19Waste = 0;
var jun20Waste = 0;
var jun21Waste = 0;
var jun22Waste = 0;
var jun23Waste = 0;
var jun24Waste = 0;
var jun25Waste = 0;
var jun26Waste = 0;
var jun27Waste = 0;
var jun28Waste = 0;
var jun29Waste = 0;
var jun30Waste = 0;

var jul1Waste = 0;
var jul2Waste = 0;
var jul3Waste = 0;
var jul4Waste = 0;
var jul5Waste = 0;
var jul6Waste = 0;
var jul7Waste = 0;
var jul8Waste = 0;
var jul9Waste = 0;
var jul10Waste = 0;
var jul11Waste = 0;
var jul12Waste = 0;
var jul13Waste = 0;
var jul14Waste = 0;
var jul15Waste = 0;
var jul16Waste = 0;
var jul17Waste = 0;
var jul18Waste = 0;
var jul19Waste = 0;
var jul20Waste = 0;
var jul21Waste = 0;
var jul22Waste = 0;
var jul23Waste = 0;
var jul24Waste = 0;
var jul25Waste = 0;
var jul26Waste = 0;
var jul27Waste = 0;
var jul28Waste = 0;
var jul29Waste = 0;
var jul30Waste = 0;
var jul31Waste = 0;

var aug1Waste = 0;
var aug2Waste = 0;
var aug3Waste = 0;
var aug4Waste = 0;
var aug5Waste = 0;
var aug6Waste = 0;
var aug7Waste = 0;
var aug8Waste = 0;
var aug9Waste = 0;
var aug10Waste = 0;
var aug11Waste = 0;
var aug12Waste = 0;
var aug13Waste = 0;
var aug14Waste = 0;
var aug15Waste = 0;
var aug16Waste = 0;
var aug17Waste = 0;
var aug18Waste = 0;
var aug19Waste = 0;
var aug20Waste = 0;
var aug21Waste = 0;
var aug22Waste = 0;
var aug23Waste = 0;
var aug24Waste = 0;
var aug25Waste = 0;
var aug26Waste = 0;
var aug27Waste = 0;
var aug28Waste = 0;
var aug29Waste = 0;
var aug30Waste = 0;
var aug31Waste = 0;

var sep1Waste = 0;
var sep2Waste = 0;
var sep3Waste = 0;
var sep4Waste = 0;
var sep5Waste = 0;
var sep6Waste = 0;
var sep7Waste = 0;
var sep8Waste = 0;
var sep9Waste = 0;
var sep10Waste = 0;
var sep11Waste = 0;
var sep12Waste = 0;
var sep13Waste = 0;
var sep14Waste = 0;
var sep15Waste = 0;
var sep16Waste = 0;
var sep17Waste = 0;
var sep18Waste = 0;
var sep19Waste = 0;
var sep20Waste = 0;
var sep21Waste = 0;
var sep22Waste = 0;
var sep23Waste = 0;
var sep24Waste = 0;
var sep25Waste = 0;
var sep26Waste = 0;
var sep27Waste = 0;
var sep28Waste = 0;
var sep29Waste = 0;
var sep30Waste = 0;

var oct1Waste = 0;
var oct2Waste = 0;
var oct3Waste = 0;
var oct4Waste = 0;
var oct5Waste = 0;
var oct6Waste = 0;
var oct7Waste = 0;
var oct8Waste = 0;
var oct9Waste = 0;
var oct10Waste = 0;
var oct11Waste = 0;
var oct12Waste = 0;
var oct13Waste = 0;
var oct14Waste = 0;
var oct15Waste = 0;
var oct16Waste = 0;
var oct17Waste = 0;
var oct18Waste = 0;
var oct19Waste = 0;
var oct20Waste = 0;
var oct21Waste = 0;
var oct22Waste = 0;
var oct23Waste = 0;
var oct24Waste = 0;
var oct25Waste = 0;
var oct26Waste = 0;
var oct27Waste = 0;
var oct28Waste = 0;
var oct29Waste = 0;
var oct30Waste = 0;
var oct31Waste = 0;

var nov1Waste = 0;
var nov2Waste = 0;
var nov3Waste = 0;
var nov4Waste = 0;
var nov5Waste = 0;
var nov6Waste = 0;
var nov7Waste = 0;
var nov8Waste = 0;
var nov9Waste = 0;
var nov10Waste = 0;
var nov11Waste = 0;
var nov12Waste = 0;
var nov13Waste = 0;
var nov14Waste = 0;
var nov15Waste = 0;
var nov16Waste = 0;
var nov17Waste = 0;
var nov18Waste = 0;
var nov19Waste = 0;
var nov20Waste = 0;
var nov21Waste = 0;
var nov22Waste = 0;
var nov23Waste = 0;
var nov24Waste = 0;
var nov25Waste = 0;
var nov26Waste = 0;
var nov27Waste = 0;
var nov28Waste = 0;
var nov29Waste = 0;
var nov30Waste = 0;

var dec1Waste = 0;
var dec2Waste = 0;
var dec3Waste = 0;
var dec4Waste = 0;
var dec5Waste = 0;
var dec6Waste = 0;
var dec7Waste = 0;
var dec8Waste = 0;
var dec9Waste = 0;
var dec10Waste = 0;
var dec11Waste = 0;
var dec12Waste = 0;
var dec13Waste = 0;
var dec14Waste = 0;
var dec15Waste = 0;
var dec16Waste = 0;
var dec17Waste = 0;
var dec18Waste = 0;
var dec19Waste = 0;
var dec20Waste = 0;
var dec21Waste = 0;
var dec22Waste = 0;
var dec23Waste = 0;
var dec24Waste = 0;
var dec25Waste = 0;
var dec26Waste = 0;
var dec27Waste = 0;
var dec28Waste = 0;
var dec29Waste = 0;
var dec30Waste = 0;
var dec31Waste = 0;

</script>

<c:forEach var="tempItem" items="${WASTED_ITEMS__PRICE_LIST}">
	
	<script>
	
	if(${tempItem.expiryDate.substring(3, 5)} == "01") {
		
		if(${tempItem.expiryDate.substring(0, 2)} == "01"){
			jan1Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "02"){
			jan2Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "03"){
			jan3Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "04"){
			jan4Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "05"){
			jan5Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "06"){
			jan6Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "07"){
			jan7Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "08"){
			jan8Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "09"){
			jan9Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "10"){
			jan10Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "11"){
			jan11Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "12"){
			jan12Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "13"){
			jan13Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "14"){
			jan14Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "15"){
			jan15Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "16"){
			jan16Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "17"){
			jan17Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "18"){
			jan18Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "19"){
			jan19Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "20"){
			jan20Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "21"){
			jan21Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "22"){
			jan22Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "23"){
			jan23Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "24"){
			jan24Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "25"){
			jan25Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "26"){
			jan26Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "27"){
			jan27Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "28"){
			jan28Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "29"){
			jan29Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "30"){
			jan30Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "31"){
			jan31Waste += parseFloat(${tempItem.price});
		}
	} 
	
	if(${tempItem.expiryDate.substring(3, 5)} == "02") {
		if(${tempItem.expiryDate.substring(0, 2)} == "01"){
			feb1Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "02"){
			feb2Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "03"){
			feb3Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "04"){
			feb4Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "05"){
			feb5Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "06"){
			feb6Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "07"){
			feb7Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "08"){
			feb8Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "09"){
			feb9Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "10"){
			feb10Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "11"){
			feb11Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "12"){
			feb12Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "13"){
			feb13Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "14"){
			feb14Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "15"){
			feb15Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "16"){
			feb16Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "17"){
			feb17Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "18"){
			feb18Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "19"){
			feb19Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "20"){
			feb20Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "21"){
			feb21Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "22"){
			feb22Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "23"){
			feb23Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "24"){
			feb24Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "25"){
			feb25Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "26"){
			feb26Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "27"){
			feb27Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "28"){
			feb28Waste += parseFloat(${tempItem.price});
		}
	}
	
	if(${tempItem.expiryDate.substring(3, 5)} == "03") {
		if(${tempItem.expiryDate.substring(0, 2)} == "01"){
			mar1Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "02"){
			mar2Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "03"){
			mar3Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "04"){
			mar4Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "05"){
			mar5Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "06"){
			mar6Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "07"){
			mar7Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "08"){
			mar8Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "09"){
			mar9Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "10"){
			mar10Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "11"){
			mar11Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "12"){
			mar12Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "13"){
			mar13Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "14"){
			mar14Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "15"){
			mar15Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "16"){
			mar16Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "17"){
			mar17Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "18"){
			mar18Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "19"){
			mar19Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "20"){
			mar20Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "21"){
			mar21Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "22"){
			mar22Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "23"){
			mar23Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "24"){
			mar24Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "25"){
			mar25Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "26"){
			mar26Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "27"){
			mar27Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "28"){
			mar28Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "29"){
			mar29Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "30"){
			mar30Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "31"){
			mar31Waste += parseFloat(${tempItem.price});
		}
	}
	
	if(${tempItem.expiryDate.substring(3, 5)} == "04") {
		if(${tempItem.expiryDate.substring(0, 2)} == "01"){
			apr1Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "02"){
			apr2Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "03"){
			apr3Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "04"){
			apr4Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "05"){
			apr5Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "06"){
			apr6Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "07"){
			apr7Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "08"){
			apr8Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "09"){
			apr9Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "10"){
			apr10Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "11"){
			apr11Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "12"){
			apr12Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "13"){
			apr13Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "14"){
			apr14Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "15"){
			apr15Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "16"){
			apr16Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "17"){
			apr17Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "18"){
			apr18Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "19"){
			apr19Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "20"){
			apr20Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "21"){
			apr21Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "22"){
			apr22Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "23"){
			apr23Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "24"){
			apr24Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "25"){
			apr25Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "26"){
			apr26Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "27"){
			apr27Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "28"){
			apr28Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "29"){
			apr29Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "30"){
			apr30Waste += parseFloat(${tempItem.price});
		}
	}
	
	if(${tempItem.expiryDate.substring(3, 5)} == "05") {
		if(${tempItem.expiryDate.substring(0, 2)} == "01"){
			may1Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "02"){
			may2Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "03"){
			may3Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "04"){
			may4Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "05"){
			may5Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "06"){
			may6Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "07"){
			may7Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "08"){
			may8Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "09"){
			may9Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "10"){
			may10Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "11"){
			may11Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "12"){
			may12Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "13"){
			may13Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "14"){
			may14Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "15"){
			may15Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "16"){
			may16Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "17"){
			may17Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "18"){
			may18Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "19"){
			may19Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "20"){
			may20Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "21"){
			may21Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "22"){
			may22Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "23"){
			may23Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "24"){
			may24Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "25"){
			may25Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "26"){
			may26Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "27"){
			may27Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "28"){
			may28Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "29"){
			may29Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "30"){
			may30Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "31"){
			may31Waste += parseFloat(${tempItem.price});
		}
	}
	
	if(${tempItem.expiryDate.substring(3, 5)} == "06") {
		if(${tempItem.expiryDate.substring(0, 2)} == "01"){
			jun1Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "02"){
			jun2Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "03"){
			jun3Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "04"){
			jun4Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "05"){
			jun5Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "06"){
			jun6Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "07"){
			jun7Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "08"){
			jun8Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "09"){
			jun9Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "10"){
			jun10Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "11"){
			jun11Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "12"){
			jun12Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "13"){
			jun13Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "14"){
			jun14Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "15"){
			jun15Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "16"){
			jun16Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "17"){
			jun17Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "18"){
			jun18Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "19"){
			jun19Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "20"){
			jun20Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "21"){
			jun21Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "22"){
			jun22Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "23"){
			jun23Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "24"){
			jun24Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "25"){
			jun25Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "26"){
			jun26Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "27"){
			jun27Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "28"){
			jun28Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "29"){
			jun29Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "30"){
			jun30Waste += parseFloat(${tempItem.price});
		}
	}
	
	if(${tempItem.expiryDate.substring(3, 5)} == "07") {
		if(${tempItem.expiryDate.substring(0, 2)} == "01"){
			jul1Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "02"){
			jul2Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "03"){
			jul3Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "04"){
			jul4Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "05"){
			jul5Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "06"){
			jul6Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "07"){
			jul7Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "08"){
			jul8Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "09"){
			jul9Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "10"){
			jul10Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "11"){
			jul11Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "12"){
			jul12Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "13"){
			jul13Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "14"){
			jul14Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "15"){
			jul15Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "16"){
			jul16Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "17"){
			jul17Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "18"){
			jul18Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "19"){
			jul19Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "20"){
			jul20Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "21"){
			jul21Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "22"){
			jul22Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "23"){
			jul23Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "24"){
			jul24Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "25"){
			jul25Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "26"){
			jul26Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "27"){
			jul27Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "28"){
			jul28Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "29"){
			jul29Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "30"){
			jul30Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "31"){
			jul31Waste += parseFloat(${tempItem.price});
		}
	}
	
	if(${tempItem.expiryDate.substring(3, 5)} == "08") {
		if(${tempItem.expiryDate.substring(0, 2)} == "01"){
			aug1Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "02"){
			aug2Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "03"){
			aug3Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "04"){
			aug4Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "05"){
			aug5Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "06"){
			aug6Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "07"){
			aug7Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "08"){
			aug8Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "09"){
			aug9Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "10"){
			aug10Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "11"){
			aug11Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "12"){
			aug12Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "13"){
			aug13Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "14"){
			aug14Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "15"){
			aug15Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "16"){
			aug16Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "17"){
			aug17Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "18"){
			aug18Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "19"){
			aug19Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "20"){
			aug20Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "21"){
			aug21Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "22"){
			aug22Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "23"){
			aug23Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "24"){
			aug24Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "25"){
			aug25Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "26"){
			aug26Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "27"){
			aug27Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "28"){
			aug28Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "29"){
			aug29Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "30"){
			aug30Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "31"){
			aug31Waste += parseFloat(${tempItem.price});
		}
	}
	
	if(${tempItem.expiryDate.substring(3, 5)} == "09") {
		if(${tempItem.expiryDate.substring(0, 2)} == "01"){
			sep1Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "02"){
			sep2Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "03"){
			sep3Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "04"){
			sep4Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "05"){
			sep5Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "06"){
			sep6Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "07"){
			sep7Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "08"){
			sep8Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "09"){
			sep9Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "10"){
			sep10Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "11"){
			sep11Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "12"){
			sep12Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "13"){
			sep13Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "14"){
			sep14Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "15"){
			sep15Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "16"){
			sep16Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "17"){
			sep17Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "18"){
			sep18Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "19"){
			sep19Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "20"){
			sep20Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "21"){
			sep21Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "22"){
			sep22Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "23"){
			sep23Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "24"){
			sep24Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "25"){
			sep25Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "26"){
			sep26Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "27"){
			sep27Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "28"){
			sep28Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "29"){
			sep29Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "30"){
			sep30Waste += parseFloat(${tempItem.price});
		}
	}
	
	if(${tempItem.expiryDate.substring(3, 5)} == "10") {
		if(${tempItem.expiryDate.substring(0, 2)} == "01"){
			oct1Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "02"){
			oct2Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "03"){
			oct3Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "04"){
			oct4Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "05"){
			oct5Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "06"){
			oct6Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "07"){
			oct7Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "08"){
			oct8Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "09"){
			oct9Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "10"){
			oct10Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "11"){
			oct11Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "12"){
			oct12Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "13"){
			oct13Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "14"){
			oct14Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "15"){
			oct15Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "16"){
			oct16Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "17"){
			oct17Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "18"){
			oct18Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "19"){
			oct19Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "20"){
			oct20Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "21"){
			oct21Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "22"){
			oct22Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "23"){
			oct23Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "24"){
			oct24Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "25"){
			oct25Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "26"){
			oct26Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "27"){
			oct27Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "28"){
			oct28Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "29"){
			oct29Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "30"){
			oct30Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "31"){
			oct31Waste += parseFloat(${tempItem.price});
		}
	}
	if(${tempItem.expiryDate.substring(3, 5)} == "11") {
		if(${tempItem.expiryDate.substring(0, 2)} == "01"){
			nov1Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "02"){
			nov2Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "03"){
			nov3Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "04"){
			nov4Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "05"){
			nov5Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "06"){
			nov6Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "07"){
			nov7Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "08"){
			nov8Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "09"){
			nov9Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "10"){
			nov10Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "11"){
			nov11Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "12"){
			nov12Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "13"){
			nov13Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "14"){
			nov14Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "15"){
			nov15Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "16"){
			nov16Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "17"){
			nov17Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "18"){
			nov18Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "19"){
			nov19Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "20"){
			nov20Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "21"){
			nov21 += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "22"){
			nov22Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "23"){
			nov23Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "24"){
			nov24Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "25"){
			nov25Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "26"){
			nov26Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "27"){
			nov27Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "28"){
			nov28Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "29"){
			nov29Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "30"){
			nov30Waste += parseFloat(${tempItem.price});
		}
	}
	
	if(${tempItem.expiryDate.substring(3, 5)} == "12") {
		if(${tempItem.expiryDate.substring(0, 2)} == "01"){
			dec1Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "02"){
			dec2Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "03"){
			dec3Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "04"){
			dec4Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "05"){
			dec5Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "06"){
			dec6Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "07"){
			dec7Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "08"){
			dec8Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "09"){
			dec9Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "10"){
			dec10Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "11"){
			dec11Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "12"){
			dec12Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "13"){
			dec13Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "14"){
			dec14Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "15"){
			dec15Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "16"){
			dec16Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "17"){
			dec17Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "18"){
			dec18Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "19"){
			dec19Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "20"){
			dec20Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "21"){
			dec21Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "22"){
			dec22Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "23"){
			dec23Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "24"){
			dec24Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "25"){
			dec25Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "26"){
			dec26Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "27"){
			dec27Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "28"){
			dec28Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "29"){
			dec29Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "30"){
			dec30Waste += parseFloat(${tempItem.price});
		}
		if(${tempItem.expiryDate.substring(0, 2)} == "31"){
			dec31Waste += parseFloat(${tempItem.price});
		}
	}
		
	</script>

</c:forEach>

<script>

var priceArrayJanWaste = [
	jan1Waste, 
	jan2Waste,
	jan3Waste,
	jan4Waste,
	jan5Waste,
	jan6Waste,
	jan7Waste,
	jan8Waste,
	jan9Waste,
	jan10Waste,
	jan11Waste,
	jan12Waste,
	jan13Waste,
	jan14Waste,
	jan15Waste,
	jan16Waste,
	jan17Waste,
	jan18Waste,
	jan19Waste,
	jan20Waste,
	jan21Waste,
	jan22Waste,
	jan23Waste,
	jan24Waste,
	jan25Waste,
	jan26Waste,
	jan27Waste,
	jan28Waste,
	jan29Waste,
	jan30Waste,
	jan31Waste
	];
	
var priceArrayFebWaste = [
	feb1Waste, 
	feb2Waste,
	feb3Waste,
	feb4Waste,
	feb5Waste,
	feb6Waste,
	feb7Waste,
	feb8Waste,
	feb9Waste,
	feb10Waste,
	feb11Waste,
	feb12Waste,
	feb13Waste,
	feb14Waste,
	feb15Waste,
	feb16Waste,
	feb17Waste,
	feb18Waste,
	feb19Waste,
	feb20Waste,
	feb21Waste,
	feb22Waste,
	feb23Waste,
	feb24Waste,
	feb25Waste,
	feb26Waste,
	feb27Waste,
	feb28Waste
	];
	
var priceArrayMarWaste = [
	mar1Waste, 
	mar2Waste,
	mar3Waste,
	mar4Waste,
	mar5Waste,
	mar6Waste,
	mar7Waste,
	mar8Waste,
	mar9Waste,
	mar10Waste,
	mar11Waste,
	mar12Waste,
	mar13Waste,
	mar14Waste,
	mar15Waste,
	mar16Waste,
	mar17Waste,
	mar18Waste,
	mar19Waste,
	mar20Waste,
	mar21Waste,
	mar22Waste,
	mar23Waste,
	mar24Waste,
	mar25Waste,
	mar26Waste,
	mar27Waste,
	mar28Waste,
	mar29Waste,
	mar30Waste,
	mar31Waste
	];
	
var priceArrayAprWaste = [
	apr1Waste, 
	apr2Waste,
	apr3Waste,
	apr4Waste,
	apr5Waste,
	apr6Waste,
	apr7Waste,
	apr8Waste,
	apr9Waste,
	apr10Waste,
	apr11Waste,
	apr12Waste,
	apr13Waste,
	apr14Waste,
	apr15Waste,
	apr16Waste,
	apr17Waste,
	apr18Waste,
	apr19Waste,
	apr20Waste,
	apr21Waste,
	apr22Waste,
	apr23Waste,
	apr24Waste,
	apr25Waste,
	apr26Waste,
	apr27Waste,
	apr28Waste,
	apr29Waste,
	apr30Waste,
	];
	
var priceArrayMayWaste = [
	may1Waste, 
	may2Waste,
	may3Waste,
	may4Waste,
	may5Waste,
	may6Waste,
	may7Waste,
	may8Waste,
	may9Waste,
	may10Waste,
	may11Waste,
	may12Waste,
	may13Waste,
	may14Waste,
	may15Waste,
	may16Waste,
	may17Waste,
	may18Waste,
	may19Waste,
	may20Waste,
	may21Waste,
	may22Waste,
	may23Waste,
	may24Waste,
	may25Waste,
	may26Waste,
	may27Waste,
	may28Waste,
	may29Waste,
	may30Waste,
	may31Waste
	];
	
var priceArrayJunWaste = [
	jun1Waste, 
	jun2Waste,
	jun3Waste,
	jun4Waste,
	jun5Waste,
	jun6Waste,
	jun7Waste,
	jun8Waste,
	jun9Waste,
	jun10Waste,
	jun11Waste,
	jun12Waste,
	jun13Waste,
	jun14Waste,
	jun15Waste,
	jun16Waste,
	jun17Waste,
	jun18Waste,
	jun19Waste,
	jun20Waste,
	jun21Waste,
	jun22Waste,
	jun23Waste,
	jun24Waste,
	jun25Waste,
	jun26Waste,
	jun27Waste,
	jun28Waste,
	jun29Waste,
	jun30Waste
	];
	
var priceArrayJulWaste = [
	jul1Waste, 
	jul2Waste,
	jul3Waste,
	jul4Waste,
	jul5Waste,
	jul6Waste,
	jul7Waste,
	jul8Waste,
	jul9Waste,
	jul10Waste,
	jul11Waste,
	jul12Waste,
	jul13Waste,
	jul14Waste,
	jul15Waste,
	jul16Waste,
	jul17Waste,
	jul18Waste,
	jul19Waste,
	jul20Waste,
	jul21Waste,
	jul22Waste,
	jul23Waste,
	jul24Waste,
	jul25Waste,
	jul26Waste,
	jul27Waste,
	jul28Waste,
	jul29Waste,
	jul30Waste,
	jul31Waste
	];
	
var priceArrayAugWaste = [
	aug1Waste, 
	aug2Waste,
	aug3Waste,
	aug4Waste,
	aug5Waste,
	aug6Waste,
	aug7Waste,
	aug8Waste,
	aug9Waste,
	aug10Waste,
	aug11Waste,
	aug12Waste,
	aug13Waste,
	aug14Waste,
	aug15Waste,
	aug16Waste,
	aug17Waste,
	aug18Waste,
	aug19Waste,
	aug20Waste,
	aug21Waste,
	aug22Waste,
	aug23Waste,
	aug24Waste,
	aug25Waste,
	aug26Waste,
	aug27Waste,
	aug28Waste,
	aug29Waste,
	aug30Waste,
	aug31Waste
	];
	
var priceArraySepWaste = [
	sep1Waste, 
	sep2Waste,
	sep3Waste,
	sep4Waste,
	sep5Waste,
	sep6Waste,
	sep7Waste,
	sep8Waste,
	sep9Waste,
	sep10Waste,
	sep11Waste,
	sep12Waste,
	sep13Waste,
	sep14Waste,
	sep15Waste,
	sep16Waste,
	sep17Waste,
	sep18Waste,
	sep19Waste,
	sep20Waste,
	sep21Waste,
	sep22Waste,
	sep23Waste,
	sep24Waste,
	sep25Waste,
	sep26Waste,
	sep27Waste,
	sep28Waste,
	sep29Waste,
	sep30Waste
	];
	
var priceArrayOctWaste = [
	oct1Waste, 
	oct2Waste,
	oct3Waste,
	oct4Waste,
	oct5Waste,
	oct6Waste,
	oct7Waste,
	oct8Waste,
	oct9Waste,
	oct10Waste,
	oct11Waste,
	oct12Waste,
	oct13Waste,
	oct14Waste,
	oct15Waste,
	oct16Waste,
	oct17Waste,
	oct18Waste,
	oct19Waste,
	oct20Waste,
	oct21Waste,
	oct22Waste,
	oct23Waste,
	oct24Waste,
	oct25Waste,
	oct26Waste,
	oct27Waste,
	oct28Waste,
	oct29Waste,
	oct30Waste,
	oct31Waste
	];
	
var priceArrayNovWaste = [
	nov1Waste, 
	nov2Waste,
	nov3Waste,
	nov4Waste,
	nov5Waste,
	nov6Waste,
	nov7Waste,
	nov8Waste,
	nov9Waste,
	nov10Waste,
	nov11Waste,
	nov12Waste,
	nov13Waste,
	nov14Waste,
	nov15Waste,
	nov16Waste,
	nov17Waste,
	nov18Waste,
	nov19Waste,
	nov20Waste,
	nov21Waste,
	nov22Waste,
	nov23Waste,
	nov24Waste,
	nov25Waste,
	nov26Waste,
	nov27Waste,
	nov28Waste,
	nov29Waste,
	nov30Waste,
	];
	
var priceArrayDecWaste = [
	dec1Waste, 
	dec2Waste,
	dec3Waste,
	dec4Waste,
	dec5Waste,
	dec6Waste,
	dec7Waste,
	dec8Waste,
	dec9Waste,
	dec10Waste,
	dec11Waste,
	dec12Waste,
	dec13Waste,
	dec14Waste,
	dec15Waste,
	dec16Waste,
	dec17Waste,
	dec18Waste,
	dec19Waste,
	dec20Waste,
	dec21Waste,
	dec22Waste,
	dec23Waste,
	dec24Waste,
	dec25Waste,
	dec26Waste,
	dec27Waste,
	dec28Waste,
	dec29Waste,
	dec30Waste,
	dec31Waste
	];


var janTotalWaste = 0;
var febTotalWaste = 0;
var marTotalWaste = 0;
var aprTotalWaste = 0;
var mayTotalWaste = 0;
var junTotalWaste = 0;
var julTotalWaste = 0;
var augTotalWaste = 0;
var sepTotalWaste = 0;
var octTotalWaste = 0;
var novTotalWaste = 0;
var decTotalWaste = 0;

for (var i = 0; i < priceArrayJanWaste.length; i++) {
	janTotalWaste += priceArrayJanWaste[i];
}

for (var i = 0; i < priceArrayFebWaste.length; i++) {
	febTotalWaste += priceArrayFebWaste[i];
}

for (var i = 0; i < priceArrayMarWaste.length; i++) {
	marTotalWaste += priceArrayMarWaste[i];
}

for (var i = 0; i < priceArrayAprWaste.length; i++) {
	aprTotalWaste += priceArrayAprWaste[i];
}

for (var i = 0; i < priceArrayMayWaste.length; i++) {
	mayTotalWaste += priceArrayMayWaste[i];
}

for (var i = 0; i < priceArrayJunWaste.length; i++) {
	junTotal+= priceArrayJun[i];
}

for (var i = 0; i < priceArrayJul.length; i++) {
	julTotalWaste += priceArrayJulWaste[i];
}

for (var i = 0; i < priceArrayAugWaste.length; i++) {
	augTotalWaste += priceArrayAugWaste[i];
}

for (var i = 0; i < priceArraySepWaste.length; i++) {
	sepTotalWaste += priceArraySepWaste[i];
}

for (var i = 0; i < priceArrayOctWaste.length; i++) {
	octTotalWaste += priceArrayOctWaste[i];
}

for (var i = 0; i < priceArrayNovWaste.length; i++) {
	novTotalWaste += priceArrayNovWaste[i];
}

for (var i = 0; i < priceArrayDecWaste.length; i++) {
	decTotalWaste += priceArrayDecWaste[i];
}

thisYearPriceArrayWaste = [
	janTotalWaste, 
	febTotalWaste, 
	marTotalWaste, 
	aprTotalWaste, 
	mayTotalWaste, 
	junTotalWaste, 
	julTotalWaste, 
	augTotalWaste, 
	sepTotalWaste, 
	octTotalWaste, 
	novTotalWaste, 
	decTotalWaste
	];


function moneyWastedButtonClicked() {
	
	document.querySelector(".chart-label-x").textContent = "Months";
    var graphDataArray = [];
    for (var i = 0; i < thisYearPriceArrayWaste.length; i++) {
        graphDataArray.push({ "y": thisYearPriceArrayWaste[i] });
    }
    var chart = new CanvasJS.Chart("chartContainer", {
        animationEnabled: true,
        theme: "light4",
        title: {
            text: "Euros Wasted This Year"
        },
        data: [{
        	type: "line",
            lineColor: "black",
            markerColor: "black",
            indexLabelFontSize: 16,
            dataPoints: graphDataArray
        }]
    });
    chart.render();
}


</script>
<script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>
</body>

</html>