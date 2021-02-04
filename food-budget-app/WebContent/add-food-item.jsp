<!DOCTYPE html>

<html>

<head>
<title>Add Food Item</title>

<style>

#header {color: black; padding-left:5%}
#container {width: 100%; padding-left:5%}


form {
	margin-top: 10px;
}

label {
	font-size: 16px; 
	width: 100px; 
	display: block; 
	text-align: right;
	margin-right: 10px;
	margin-top: 8px;
	margin-bottom: 8px;
}

input {
	width: 250px;
	border: 1px solid #666; 
	border-radius: 5px; 
	padding: 4px; 
	font-size: 16px;
}

.save {
	font-weight: bold;
	width: 130px; 
	padding: 5px 10px; 
	margin-top: 30px;
	background: #cccccc;
}

table {   
	border-style:none;
	width:50%;
}

tr {
	border-style:none;
	text-align:left;	
}

</style>
</head>
<body>

<div id="header">
<h2>Food Budgeting App</h2>
</div>

<div id="container">
<h3>Add Food Item</h3>

<form action="FoodItemControllerServlet" method="POST" onsubmit="return checkInputs()" >
<input type="hidden" name="command" value="ADD" />

<table>
<tbody>
<tr>
<td><label>Item:</label></td>
<td><input type="text" name="item" /></td>
</tr>
<tr>
<td><label>Expiry Date:</label></td>
<td><input type="text" name="expiryDate" value="dd-mm-yyyy" id="expiryDateInput" /> 

    <script>

        function checkInputs() {
        	
            var expiryDate = document.getElementById("expiryDateInput").value;
            var price = document.getElementById("priceInput").value;
            
            var expiryDateTest = parseInt(expiryDate.substring(0, 2) + expiryDate.substring(3, 5) + expiryDate.substring(6));
			var priceInputTest = parseFloat(price);
            
            if (expiryDateTest >= 1012021 && price > 0) {
                return true;
            } else{
            	if(expiryDateTest < 1012021 && price > 0){
            		alert("Enter only numbers for expiry date in format: dd-mm-yyyy");
                    return false;
            	}
            	else if (expiryDateTest >= 1012021 && price <= 0){
            		alert("Enter only numbers for price in format: 0.00");
                    return false;
            	}
            	else {
            		alert("Enter only numbers for expiry date in format: dd-mm-yyyy and only numbers for price in format: 0.00");
                    return false;
            	}
            }
        }
    </script>
</td>
</tr>
<tr>
<td><label>Price:</label></td>
<td><input type="text" name="price" value="0.00" id="priceInput" />
</td>
</tr>
<tr>
<td><label></label></td>
<td><input type="submit" value="save" class="save" /></td>
</tr>
</tbody></table>
</form>

<div style="clear: both;"></div>

<p>
<a href="FoodItemControllerServlet">Back to List</a>
</p>
</div>

</body>
</html>