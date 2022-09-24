<html>
<head>
	<title>COVID-19 Bed Availabilty System</title>
	 <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <link href="style.css" rel="stylesheet" type="text/css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat&family=Teko:wght@500&display=swap" rel="stylesheet">
	 <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

	<!-- Optional theme -->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">
	<title>SelectAll</title>
    <style>
	html{
		min-height:100%;
	}
	.slidecontainer
	{
		display:flex;
		width:30%;
	}
		.slider {
		  -webkit-appearance: none;
		  width: 10%;
		  height: 15px;
		  background: #d3d3d3;
		  outline: none;
		  opacity: 0.7;
		  -webkit-transition: .2s;
		  transition: opacity .2s;
		}

        body{
            background-color:rgba(107, 147, 207, 0.795);
			min-height:100%;
        }
        table{
            text-align: center;
            width: 50%;
        }
		.search1{
			display:flex;
			padding:10px;
		}
        th{
            border: 1px solid black;
            background-color: aliceblue;
            font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        h1{
            text-align: center;
        }
        td{
            border: 1px solid black;
            background-color: aliceblue;
            font-family: 'Montserrat', sans-serif;
        }
		
        .main{
            display: flex;
            justify-content: center;
        }
		.f4{
			display:flex;
			justify-content:center;
		}
        .main form[type="submit"]{
            background-color:rgba(107, 147, 207, 0.795);
        }
		footer{
		  position:fixed;
		  bottom:0;
		  left:0;
		}
		
		.form-group{
			display:flex;
			margin-left:10px;
		}
		.dropdownlist{
			margin-left:82.5%;
		}
		.slider::-webkit-slider-thumb {
			  -webkit-appearance: none;
			  appearance: none;
			  width: 10%;
			  height: 10%;
			  background: #04AA6D;
			  cursor: pointer;
		}	
		.slider::-moz-range-thumb {
		  width: 15px;
		  height: 15px;
		  background: #04AA6D;
		  cursor: pointer;
		}
		
		
		.allbtn{
			display:flex;
		}

		.search{
			margin-left:5px;
		}

		.dropdownbtn{
			margin-left:10px;
		}

		.apibox
		{
			margin-left:10px;
			margin-right:5px;
			width:20%;
		}
		.tokenbox
		{
			display:flex;
		}
		.btn{
			margin-left:5px;
		}

		
		
		
		
    </style>

   
    </head>

    <body>
	<%@page import="java.util.*"%>

     <%
	 	String username="";
	 	try{
	 	session=request.getSession(false);  
        String n=(String)session.getAttribute("username");  
		username=n;
		if(n.length()<1)	response.sendRedirect("http://localhost:8080/CBA");
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		
        ArrayList<String> std = new ArrayList<>();

        std=(ArrayList<String>)request.getAttribute("data");
            request.getSession().setAttribute("data", std);
        
    %>
    <nav class="navbar navbar-light" style="background-color: #e3f2fd;">
    <ul class="nav navbar-nav navbar-right">
        <li class="dropdown">
          <a class="dropdown-toggle" data-toggle="dropdown" href="#"><span class="glyphicon glyphicon-user"></span><%= username%> <span class="caret"></span></a>
          <ul class="dropdown-menu">
            <li><a href="LogoutServlet">Logout</a></li>
          </ul>
        </li>
    </ul>
     <div class="title">
        <a class="navbar-brand mx-auto" href="Selectall">COVID-19 Bed Availabilty System</a>
     </div>
    </nav>
    

	<div class="allbtn">
   <!-- <button class="btn btn-light" onclick="loc()">Nearby Hospitals</button> -->
    <button class="btn btn-light" onclick="loadAjax()">All Hospitals</button>
	<button class="btn btn-light" onclick="Publish()" id="npublish">Publish</button>
	<button class="btn btn-light" onclick="showSearch()" id="showSearch">Search</button>
	</div>
	<br>
	<div class="tokenbox">
		<input type="text" id="apibox" name="apibox" class="apibox">
		<button type="submit" id="abutton" class="btn btn-light" onclick="copy()">Copy to Clipboard</button>
		<button type="submit" id="bbutton" class="btn btn-light" onclick="hideapi()">hide</button>
	</div>
	
		<!--<select name="item" id="dropdownbtn">
			<option value="null">Search By</option>
			<option value="hospitals.hospital_id">ID</option>
			<option value="hospitals.Hospital_Name">Name</option>
			<option value="hospitals.location">Location</option>
			<option value="hospital_information.normal_bed">Normal Beds</option>
			<option value="hospital_information.oxygen_bed">Oxygen Beds</option>
			<option value="hospital_information.icu_bed">ICU Beds</option>
		 </select> -->
	
		 <div class="search1" id="search1">
			  <input type="text" name="search" placeholder="Name" id="hosname" class="search">
			  <input type="text" name="search" placeholder="Location" id="hoslocation" class="search">
		</div>
			  <div class="search2">
			  <select name="item1" id="dropdownbtn1" class="dropdownbtn">
			    <option value="0">select</option>
				<option value=">">Greater than</option>
				<option value="<">Less than</option>
			  </select>
			  <input type="text" name="search" placeholder="Normal Beds" id="normalbed" class="search">
			  </div>
			  
			  <div class="search3">
			  <select name="item2" id="dropdownbtn2" class="dropdownbtn">
			    <option value="0">select</option>
				<option value=">">Greater than</option>
				<option value="<">Less than</option>
			  </select>
			  <input type="text" name="search" placeholder="Oxygen Beds" id="oxygenbed" class="search">
			  </div>

			<div class="search4">
			   <select name="item3" id="dropdownbtn3" class="dropdownbtn">
			    <option value="0">select</option>
				<option value=">">Greater than</option>
				<option value="<">Less than</option>
			  </select>
			  <input type="text" name="search" placeholder="ICU Beds" id="icubed" class="search">
			  <button onclick="search()" class="search">Search</button>
			</div>
		
	
	
	 
	
	<div id="button3">
	
	<!-- <button class="btn btn-light" onclick="locpublish()" id="publish" style="display:none">Publish</button> -->
	
	</div>
    <span id="link"></span>
    <span id="temp"></span>
      
    <br>

    <p id="print"></p>
    <div id="tad">
    <div class="f1">
        <div class="main">  
        <table id="data" class="table table-hover">
            <tr>
                <th>
                    Hospital ID
                </th>
                <th>
                    Hospital Name
                </th>
                <th>
                    Location
                </th>
                <th>
                    Normal Beds
                </th>
                <th>
                    Oxygen Beds
                </th>
                <th>
                    ICU Beds
                </th>
            </tr>
            <%
                ListIterator<String> it = std.listIterator();
				int i=0;
                while(it.hasNext()){
                    String rn=it.next();
                    String na=it.next();
                    String pe=it.next();
                    String ad=it.next();
                    String obed=it.next();
                    String ibed=it.next();
            %>
        
        

        <tr id="row<%=i%>">
            <td>
                <input type="text" name="id" id="id" value="<%=rn%>" readonly>
            </td>
            <td>
                <input type="text" name="name" id="name" value="<%=na%>" readonly>
            </td>
            <td>
                <input type="text" name="location" id="location" value="<%=pe%>" readonly>
            </td>
            <td>
                <input type="text" name="nbed" id="nbed" value="<%=ad%>" readonly>
            </td>
            <td>
                <input type="text" name="obed" id="obed" value="<%=obed%>" readonly>
            </td>
            <td>
                <input type="text" name="ibed" id="ibed" value="<%=ibed%>" readonly>
            </td>
        </form>
       <% 
	   i++;
        } 
        %>       </tr>
   </table>
   <footer class="footer" >
	  <div class="container">      
			<div class="form-group" id="url">
			  <input class="form-control" placeholder="Generated link appears here" type="text" id="myInput">
			<button type="submit" class="btn btn-light" onclick="copy()">Copy to Clipboard</button>
			</div>

	  </div>
	</footer>
	<script>
		var tb=document.getElementById('url');
		tb.style.display="none";

		var abox=document.getElementById('apibox');
		abox.style.display="none";
		
		var apibutton=document.getElementById('abutton');
		apibutton.style.display="none";

		var hidebutton=document.getElementById('bbutton');
		hidebutton.style.display="none";

		
		let a=0;
		
	function search()
	{
		var name=document.getElementById('hosname').value;
		console.log(name);
		var location=document.getElementById('hoslocation').value;
		console.log(location);
		var nbed=document.getElementById('normalbed').value;
		var obed=document.getElementById('oxygenbed').value;
		var ibed=document.getElementById('icubed').value;

		if(name=="") alert("Enter Hospital name");
		if(location=="") alert("Enter Location");

		if(nbed=="" && obed=="" && ibed=="")
		{
			alert("Enter bed count");
		}
		if(isNaN(nbed))
		{
			alert("Please enter numeric value for normal bed");
		}
		if(isNaN(obed))
		{
			alert("Please enter numeric value for oxygen bed");
		}
		if(isNaN(ibed))
		{
			alert("Please enter numeric value for icu beds");
		}
		
		console.log(name+" "+location+" "+nbed+" "+obed+" "+ibed);
		
		var drop1=document.getElementById('dropdownbtn1').value;
		var drop2=document.getElementById('dropdownbtn2').value;
		var drop3=document.getElementById('dropdownbtn3').value;

		console.log(drop1+" "+drop2+" "+drop3);

		var url="Search";

		var data = {
				"data":[
					{
						"type":"hospitals",
						"id":"13",
						"attributes":{
							"hospital_name":name,
							"location":location,
							"normal_beds":nbed,
							"oxygen_beds":obed,
							"icu_beds":ibed,
							"nbox":drop1,
							"obox":drop2,
							"ibox":drop3
						}
					}
					]
				};

			ajaxGetRequest(url,injectionOfNewRow);

			function ajaxGetRequest(path, callback){
				let request = new XMLHttpRequest();
				request.onreadystatechange = function(){
					if (this.readyState === 4 && this.status === 200){
						callback(this.response);
					}
				};
				request.open("POST", path);
				request.setRequestHeader("Content-Type", "application/vnd.api+json");
				request.send(JSON.stringify(data));
			}

			function injectionOfNewRow(resp) {
				console.log(resp);

				// var testing ={"data":[{"attributes":{"hid":"101","icu_beds":"13","location":"Chennai","oxygen_beds":"10","normal_beds":"10","hospital_name":"Apollo"},"id":"1","type":"hospitals"},{"attributes":{"hid":"102","icu_beds":"20","location":"Tirunelveli","oxygen_beds":"23","normal_beds":"23","hospital_name":"Galaxy"},"id":"2","type":"hospitals"},{"attributes":{"hid":"103","icu_beds":"13","location":"Tirunelveli","oxygen_beds":"12","normal_beds":"11","hospital_name":"Shifa"},"id":"3","type":"hospitals"},{"attributes":{"hid":"104","icu_beds":"27","location":"Chennai","oxygen_beds":"26","normal_beds":"25","hospital_name":"Stanly"},"id":"4","type":"hospitals"},{"attributes":{"hid":"105","icu_beds":"12","location":"Tirunelveli","oxygen_beds":"11","normal_beds":"10","hospital_name":"TMC"},"id":"5","type":"hospitals"},{"attributes":{"hid":"106","icu_beds":"17","location":"Vellore","oxygen_beds":"16","normal_beds":"15","hospital_name":"VMC"},"id":"6","type":"hospitals"},{"attributes":{"hid":"107","icu_beds":"31","location":"Trichy","oxygen_beds":"30","normal_beds":"29","hospital_name":"BHEL"},"id":"7","type":"hospitals"},{"attributes":{"hid":"108","icu_beds":"12","location":"Tirunelveli","oxygen_beds":"11","normal_beds":"10","hospital_name":"GH"},"id":"8","type":"hospitals"},{"attributes":{"hid":"109","icu_beds":"12","location":"Madurai","oxygen_beds":"11","normal_beds":"10","hospital_name":"Mission"},"id":"9","type":"hospitals"},{"attributes":{"hid":"110","icu_beds":"17","location":"Chennai","oxygen_beds":"12","normal_beds":"12","hospital_name":"MMC"},"id":"10","type":"hospitals"},{"attributes":{"hid":"111","icu_beds":"11","location":"FF","oxygen_beds":"11","normal_beds":"11","hospital_name":"DEF"},"id":"11","type":"hospitals"},{"attributes":{"hid":"112","icu_beds":"12","location":"hdj","oxygen_beds":"11","normal_beds":"10","hospital_name":"RKO"},"id":"12","type":"hospitals"},{"attributes":{"hid":"113","icu_beds":"12","location":"DEF","oxygen_beds":"10","normal_beds":"9","hospital_name":"RKO"},"id":"13","type":"hospitals"}]};
				var testing = JSON.parse(resp);
				console.log(testing	);
			var datas = testing.data;

			var row = 0;
			var rowshtml = '<tbody><tr> <th> Hospital ID </th> <th> Hospital Name </th> <th> Location </th> <th> Normal Beds </th> <th> Oxygen Beds </th> <th> ICU Beds </th> <th colspan="2"> Actions </th> </tr>';
			var alter = document.getElementById("data");
			datas.forEach(data => {
				data = data.attributes;
				rowshtml+='<tr id="row'+row+'">\
						<td>\
							<input type="text" name="id" id="id" value="'+data.hid+'" pwa2-uuid="EDITOR/input-B30-159-55FB6-5D0" pwa-fake-editor="">\
						</td>\
						<td>\
							<input type="text" name="name" id="name" value="'+data.hospital_name+'" pwa2-uuid="EDITOR/input-4B9-DE2-3B130-35F" pwa-fake-editor="">\
						</td>\
						<td>\
							<input type="text" name="location" id="location" value="'+data.location+'" pwa2-uuid="EDITOR/input-9C0-88D-E1565-DA0" pwa-fake-editor="">\
						</td>\
						<td>\
							<input type="text" name="nbed" id="nbed" value="'+data.normal_beds+'" pwa2-uuid="EDITOR/input-7D6-A34-8484E-B3F" pwa-fake-editor="">\
						</td>\
						<td>\
							<input type="text" name="obed" id="obed" value="'+data.oxygen_beds+'" pwa2-uuid="EDITOR/input-87F-64F-97785-FCD" pwa-fake-editor="">\
						</td>\
						<td>\
							<input type="text" name="ibed" id="ibed" value="'+data.icu_beds+'" pwa2-uuid="EDITOR/input-194-064-24C22-28D" pwa-fake-editor="">\
						</td>\
						<td>\
							<input type="hidden" name="type" value="edit">\
							<button type="button" onclick="loadAjax(`row'+row+'`)">edit</button>\
						</td>\
						<td>\
							<input type="hidden" name="sid" value="101" id="sid">\
							<button type="button" onclick="loadAjax2(`row'+row+'`)">Delete</button>\
						</td>\
					</tr>';
					rowshtml+='</tbody>';
					alter.innerHTML = rowshtml;
					row++;
					console.log(data);
				});
			}
			
		
		
		
		
		
		
	}
	
	function hideapi()
	{
		abox.style.display="none";
		apibutton.style.display="none";
		hidebutton.style.display="none";	
	}



	function generateApi() 
	{
		var user="<%=request.getRemoteUser()%>";
		var url="Token?username="+user;

		 ajaxGetRequest(url,displayResponse);

			function ajaxGetRequest(path, callback){
				let request = new XMLHttpRequest();
				request.onreadystatechange = function(){
					if (this.readyState === 4 && this.status === 200){
						callback(this.response);
					}
				};
                request.open("POST", path);
                request.setRequestHeader("Content-Type", "application/vnd.api+json");
				request.send();
			}

			function displayResponse(resp)
			{
				abox.style.display="block";
				apibutton.style.display="block";
				hidebutton.style.display="block";
				abox.value = resp.toString();
			}



	}

    function loc()
    {
        a++;
        html='<div id=dform'+a+'>\
        <input type="text" name="nloc" placeholder="Location">\
        <button onclick="hide(`dform`+a)">submit</button>\
        </div>'
        var ip=document.getElementById('temp');
        ip.innerHTML+=html;
    }
    function hide(y)
    {
        var x=document.getElementById(y);
        x.style.display="none";
		// var button=document.getElementById('publish');
		//console.log(button);  
		// button.style.display="inline";
        loadAjax1(y);
		// button.style.display="block";
    }
	var l="";
    function loadAjax1(x)
    {
        var t=document.getElementById(x);
        console.log(t);
		var location=t.children[0].value;
		l=location;
        console.log(location);
        var url="Location?location="+location;

         ajaxGetRequest(url,injectionOfNewRow);

			function ajaxGetRequest(path, callback){
				let request = new XMLHttpRequest();
				request.onreadystatechange = function(){
					if (this.readyState === 4 && this.status === 200){
						callback(this.response);
					}
				};
                request.open("GET", path);
                request.setRequestHeader("Content-Type", "application/vnd.api+json");
				request.send();
			}

			function injectionOfNewRow(resp) {
				console.log(resp);

				// var testing ={"data":[{"attributes":{"hid":"101","icu_beds":"13","location":"Chennai","oxygen_beds":"10","normal_beds":"10","hospital_name":"Apollo"},"id":"1","type":"hospitals"},{"attributes":{"hid":"102","icu_beds":"20","location":"Tirunelveli","oxygen_beds":"23","normal_beds":"23","hospital_name":"Galaxy"},"id":"2","type":"hospitals"},{"attributes":{"hid":"103","icu_beds":"13","location":"Tirunelveli","oxygen_beds":"12","normal_beds":"11","hospital_name":"Shifa"},"id":"3","type":"hospitals"},{"attributes":{"hid":"104","icu_beds":"27","location":"Chennai","oxygen_beds":"26","normal_beds":"25","hospital_name":"Stanly"},"id":"4","type":"hospitals"},{"attributes":{"hid":"105","icu_beds":"12","location":"Tirunelveli","oxygen_beds":"11","normal_beds":"10","hospital_name":"TMC"},"id":"5","type":"hospitals"},{"attributes":{"hid":"106","icu_beds":"17","location":"Vellore","oxygen_beds":"16","normal_beds":"15","hospital_name":"VMC"},"id":"6","type":"hospitals"},{"attributes":{"hid":"107","icu_beds":"31","location":"Trichy","oxygen_beds":"30","normal_beds":"29","hospital_name":"BHEL"},"id":"7","type":"hospitals"},{"attributes":{"hid":"108","icu_beds":"12","location":"Tirunelveli","oxygen_beds":"11","normal_beds":"10","hospital_name":"GH"},"id":"8","type":"hospitals"},{"attributes":{"hid":"109","icu_beds":"12","location":"Madurai","oxygen_beds":"11","normal_beds":"10","hospital_name":"Mission"},"id":"9","type":"hospitals"},{"attributes":{"hid":"110","icu_beds":"17","location":"Chennai","oxygen_beds":"12","normal_beds":"12","hospital_name":"MMC"},"id":"10","type":"hospitals"},{"attributes":{"hid":"111","icu_beds":"11","location":"FF","oxygen_beds":"11","normal_beds":"11","hospital_name":"DEF"},"id":"11","type":"hospitals"},{"attributes":{"hid":"112","icu_beds":"12","location":"hdj","oxygen_beds":"11","normal_beds":"10","hospital_name":"RKO"},"id":"12","type":"hospitals"},{"attributes":{"hid":"113","icu_beds":"12","location":"DEF","oxygen_beds":"10","normal_beds":"9","hospital_name":"RKO"},"id":"13","type":"hospitals"}]};
				var testing = JSON.parse(resp);
				console.log(testing	);
            
                var datas = testing.data;
                console.log(datas);
           
                var row = 0;
                var rowshtml = '<tbody><tr> <th> Hospital ID </th> <th> Hospital Name </th> <th> Location </th> <th> Normal Beds </th> <th> Oxygen Beds </th> <th> ICU Beds </th></tr>';
                var alter = document.getElementById("data");
                var check=0;
                datas.forEach(data => {
                    data = data.attributes;
                    if(data.hid)
                    {
                        check=1;
                    }
                    rowshtml+='<tr id="row'+row+'">\
                            <td>\
                                <input type="text" name="id" id="id" value="'+data.hid+'" pwa2-uuid="EDITOR/input-B30-159-55FB6-5D0" pwa-fake-editor="">\
                            </td>\
                            <td>\
                                <input type="text" name="name" id="name" value="'+data.hospital_name+'" pwa2-uuid="EDITOR/input-4B9-DE2-3B130-35F" pwa-fake-editor="">\
                            </td>\
                            <td>\
                                <input type="text" name="location" id="location" value="'+data.location+'" pwa2-uuid="EDITOR/input-9C0-88D-E1565-DA0" pwa-fake-editor="">\
                            </td>\
                            <td>\
                                <input type="text" name="nbed" id="nbed" value="'+data.normal_beds+'" pwa2-uuid="EDITOR/input-7D6-A34-8484E-B3F" pwa-fake-editor="">\
                            </td>\
                            <td>\
                                <input type="text" name="obed" id="obed" value="'+data.oxygen_beds+'" pwa2-uuid="EDITOR/input-87F-64F-97785-FCD" pwa-fake-editor="">\
                            </td>\
                            <td>\
                                <input type="text" name="ibed" id="ibed" value="'+data.icu_beds+'" pwa2-uuid="EDITOR/input-194-064-24C22-28D" pwa-fake-editor="">\
                            </td>\
                        </tr>';
                        rowshtml+='</tbody>';
                        alter.innerHTML = rowshtml;
                        row++;
                        
                    });
                    if(check==0)
                    {
                        alert("No hospitals to display !");
                        alter.innerHTML ="";
                    }
			}
            

           
    }

	function copy()
	{
		 var copyText = document.getElementById("apibox");

		copyText.select();
		copyText.setSelectionRange(0, 99999);
		navigator.clipboard.writeText(copyText.value);
	}
	
	function publish(x){
		 var t=document.getElementById(x);
		 console.log(t);
		 var id=t.children[0].children[0].value;
		 console.log(location);
		
		 var url="Map?id="+id;

         ajaxGetRequest(url,injectionOfNewRow);

			function ajaxGetRequest(path, callback){
				let request = new XMLHttpRequest();
				request.onreadystatechange = function(){
					if (this.readyState === 4 && this.status === 200){
						callback(this.response);
					}
				};
                request.open("POST", path);
				request.send();
			}
			
			function injectionOfNewRow(resp) {
				var box=document.getElementById("myInput");
				console.log(resp);
				tb.style.display="block";
				box.value=resp;
			}
	}
	

	
	function Publish()
	{
		var name=document.getElementById('hosname').value;
		var location=document.getElementById('hoslocation').value;
		var nbed=document.getElementById('normalbed').value;
		var obed=document.getElementById('oxygenbed').value;
		var ibed=document.getElementById('icubed').value;

		var drop1=document.getElementById('dropdownbtn1').value;
		var drop2=document.getElementById('dropdownbtn2').value;
		var drop3=document.getElementById('dropdownbtn3').value;

		tb.style.display="none";
		
		var url="Map?name="+name+"&location="+location+"&nbed="+nbed+"&obed="+obed+"&ibed="+ibed+"&bed1="+drop1+"&bed2="+drop2+"&bed3="+drop3;

         ajaxGetRequest(url,injectionOfNewRow);

			function ajaxGetRequest(path, callback){
				let request = new XMLHttpRequest();
				request.onreadystatechange = function(){
					if (this.readyState === 4 && this.status === 200){
						callback(this.response);
					}
				};
                request.open("POST", path);
				request.send();
			}
			
			function injectionOfNewRow(resp) {
				
				var box=document.getElementById("myInput");
				console.log(resp);
				tb.style.display="block";
				box.value=resp;
				var name=document.getElementById('hosname');
				name.value="";
				var location=document.getElementById('hoslocation');
				location.value="";
				var nbed=document.getElementById('normalbed');
				nbed.value="";
				var obed=document.getElementById('oxygenbed');
				obed.value="";
				var ibed=document.getElementById('icubed');
				ibed.value="";
				
				var drp=document.getElementById('dropdownbtn1');
				drp.value="0";
				var drp1=document.getElementById('dropdownbtn2');
				drp1.value="0";
				var drp2=document.getElementById('dropdownbtn3');
				drp2.value="0";

			}
		
		
		
		
	}
	
    function loadAjax(){

			var location=document.getElementById('hoslocation');
			console.log(location);

			var name=document.getElementById('hosname');
				name.value="";
				var location=document.getElementById('hoslocation');
				location.value="";
				var nbed=document.getElementById('normalbed');
				nbed.value="";
				var obed=document.getElementById('oxygenbed');
				obed.value="";
				var ibed=document.getElementById('icubed');
				ibed.value="";
				
				var drp=document.getElementById('dropdownbtn1');
				drp.value="0";
				var drp1=document.getElementById('dropdownbtn2');
				drp1.value="0";
				var drp2=document.getElementById('dropdownbtn3');
				drp2.value="0";

            
            var url="Ajax";

           ajaxGetRequest(url,injectionOfNewRow);

			function ajaxGetRequest(path, callback){
				let request = new XMLHttpRequest();
				request.onreadystatechange = function(){
					if (this.readyState === 4 && this.status === 200){
						callback(this.response);
					}
				};
				request.open("GET", path);
                request.setRequestHeader("Content-Type", "application/vnd.api+json");
                request.send();
			}

			function injectionOfNewRow(resp) {
				console.log(resp);
				var sb=document.getElementById('hosname');
				sb.value="";
				tb.style.display="none";
				
				// var testing ={"data":[{"attributes":{"hid":"101","icu_beds":"13","location":"Chennai","oxygen_beds":"10","normal_beds":"10","hospital_name":"Apollo"},"id":"1","type":"hospitals"},{"attributes":{"hid":"102","icu_beds":"20","location":"Tirunelveli","oxygen_beds":"23","normal_beds":"23","hospital_name":"Galaxy"},"id":"2","type":"hospitals"},{"attributes":{"hid":"103","icu_beds":"13","location":"Tirunelveli","oxygen_beds":"12","normal_beds":"11","hospital_name":"Shifa"},"id":"3","type":"hospitals"},{"attributes":{"hid":"104","icu_beds":"27","location":"Chennai","oxygen_beds":"26","normal_beds":"25","hospital_name":"Stanly"},"id":"4","type":"hospitals"},{"attributes":{"hid":"105","icu_beds":"12","location":"Tirunelveli","oxygen_beds":"11","normal_beds":"10","hospital_name":"TMC"},"id":"5","type":"hospitals"},{"attributes":{"hid":"106","icu_beds":"17","location":"Vellore","oxygen_beds":"16","normal_beds":"15","hospital_name":"VMC"},"id":"6","type":"hospitals"},{"attributes":{"hid":"107","icu_beds":"31","location":"Trichy","oxygen_beds":"30","normal_beds":"29","hospital_name":"BHEL"},"id":"7","type":"hospitals"},{"attributes":{"hid":"108","icu_beds":"12","location":"Tirunelveli","oxygen_beds":"11","normal_beds":"10","hospital_name":"GH"},"id":"8","type":"hospitals"},{"attributes":{"hid":"109","icu_beds":"12","location":"Madurai","oxygen_beds":"11","normal_beds":"10","hospital_name":"Mission"},"id":"9","type":"hospitals"},{"attributes":{"hid":"110","icu_beds":"17","location":"Chennai","oxygen_beds":"12","normal_beds":"12","hospital_name":"MMC"},"id":"10","type":"hospitals"},{"attributes":{"hid":"111","icu_beds":"11","location":"FF","oxygen_beds":"11","normal_beds":"11","hospital_name":"DEF"},"id":"11","type":"hospitals"},{"attributes":{"hid":"112","icu_beds":"12","location":"hdj","oxygen_beds":"11","normal_beds":"10","hospital_name":"RKO"},"id":"12","type":"hospitals"},{"attributes":{"hid":"113","icu_beds":"12","location":"DEF","oxygen_beds":"10","normal_beds":"9","hospital_name":"RKO"},"id":"13","type":"hospitals"}]};
				var testing = JSON.parse(resp);
				console.log(testing	);
			var datas = testing.data;

			var row = 0;
			var rowshtml = '<tbody><tr> <th> Hospital ID </th> <th> Hospital Name </th> <th> Location </th> <th> Normal Beds </th> <th> Oxygen Beds </th> <th> ICU Beds </th> </tr>';
			var alter = document.getElementById("data");
			datas.forEach(data => {
				data = data.attributes;
				rowshtml+='<tr id="row'+row+'">\
						<td>\
							<input type="text" name="id" id="id" value="'+data.hid+'" pwa2-uuid="EDITOR/input-B30-159-55FB6-5D0" pwa-fake-editor="">\
						</td>\
						<td>\
							<input type="text" name="name" id="name" value="'+data.hospital_name+'" pwa2-uuid="EDITOR/input-4B9-DE2-3B130-35F" pwa-fake-editor="">\
						</td>\
						<td>\
							<input type="text" name="location" id="location" value="'+data.location+'" pwa2-uuid="EDITOR/input-9C0-88D-E1565-DA0" pwa-fake-editor="">\
						</td>\
						<td>\
							<input type="text" name="nbed" id="nbed" value="'+data.normal_beds+'" pwa2-uuid="EDITOR/input-7D6-A34-8484E-B3F" pwa-fake-editor="">\
						</td>\
						<td>\
							<input type="text" name="obed" id="obed" value="'+data.oxygen_beds+'" pwa2-uuid="EDITOR/input-87F-64F-97785-FCD" pwa-fake-editor="">\
						</td>\
						<td>\
							<input type="text" name="ibed" id="ibed" value="'+data.icu_beds+'" pwa2-uuid="EDITOR/input-194-064-24C22-28D" pwa-fake-editor="">\
						</td>\
					</tr>';
					rowshtml+='</tbody>';
					alter.innerHTML = rowshtml;
					row++;
					
				});
			}

			
        }
		function boxshow()
		{
			var sbtn=document.getElementById("searchbutton");
			sbtn.style.display="none";
			submit.style.display="block";
		}
		
	</script>
</div>
</div>
</div>