<html>
<head>

	 <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat&family=Teko:wght@500&display=swap" rel="stylesheet">
	 <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

	<!-- Optional theme -->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">
	<style>
        body{
            background-color:rgba(107, 147, 207, 0.795);
        }
        table{
            text-align: center;
            width: 50%;
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
    </style>
	

</head>

	
	
	<body>
	     <nav class="navbar navbar-light" style="background-color: #e3f2fd;">
    
		 <div class="title">
			<a class="navbar-brand mx-auto" href="Selectall">Bed Availability Report</a>
		 </div>
		</nav>
		
		 <%@page import="java.util.*"%>
		 <%@page import="java.sql.*"%>
		 <%@page import="org.json.*"%>
		 <%@page import="org.json.simple.JSONArray"%>
		<%
			String url=request.getRequestURI();
			String hash=url.substring(12);
			System.out.println(hash);

			 try{
				 Connection con=DriverManager.getConnection("jdbc:mysql://localhost/covid","root","Gokul@2001");
				  PreparedStatement st=null;
				  String query="select name,location,nbed,obed,ibed,cond1,cond2,cond3 from url2 where hash=?";
				  st=con.prepareStatement(query);
				  st.setString(1,hash);
				  ResultSet rs=st.executeQuery();
				  String name="";
				  String location="";
				  String nbed="";
				  String obed="";
				  String ibed="";
				  String cond1="";
				  String cond2="";
				  String cond3="";
				  while(rs.next())
				  {
					name=rs.getString(1);
					location=rs.getString(2);
					nbed=rs.getString(3);
					obed=rs.getString(4);
					ibed=rs.getString(5);
					cond1=rs.getString(6);
					cond2=rs.getString(7);
					cond3=rs.getString(8);
				  }
				  String name1=name+"%";
				   Statement st1 = con.createStatement();
					String sql="select hospitals.hospital_id,hospital_information.Hospital_Name,hospitals.location,hospital_information.normal_bed,hospital_information.oxygen_bed,hospital_information.icu_bed FROM hospitals INNER JOIN hospital_information ON hospitals.hospital_id=hospital_information.hospital_id where hospitals.Hospital_Name LIKE '"+name1+"'and hospitals.location= '"+location+"'and hospital_information.normal_bed"+cond1+"'"+nbed+"' and hospital_information.oxygen_bed"+cond2+"'"+obed+"'and hospital_information.icu_bed"+cond3+"'"+ibed+"'";
					System.out.println(sql);					
						
				  
					ResultSet rs1=st1.executeQuery(sql);
					JSONObject json=new JSONObject();
					JSONArray arr=new JSONArray();
					ArrayList<String> al= new ArrayList<>();
					int i=1;
				%>
					<br><br><br>
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
					while(rs1.next()){
								JSONObject details=new JSONObject();
								details.put("type","hospitals");
								details.put("id",i+"");
								JSONObject attributes=new JSONObject();
								i++;
								String rn=(rs1.getInt(1)+"");
								String na=rs1.getString(2);
								String pe=rs1.getString(3);
								String ad=rs1.getString(4);
								String oxbed=rs1.getString(5);
								String icbed=rs1.getString(6);
								attributes.put("hid",rn);
								attributes.put("hospital_name",na);
								attributes.put("location",pe);
								attributes.put("normal_beds",ad);
								attributes.put("oxygen_beds",oxbed);
								attributes.put("icu_beds",icbed);
								details.put("attributes",attributes);
								arr.add(details);
								al.add(rn);
								al.add(na);
								al.add(pe);
								al.add(ad);
								al.add(oxbed);
								al.add(icbed);
					%>
					
		<tr>
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
                <input type="text" name="obed" id="obed" value="<%=oxbed%>" readonly>
            </td>
            <td>
                <input type="text" name="ibed" id="ibed" value="<%=icbed%>" readonly>
            </td>
        </form>
		</tr>
		<%
					}
					json.put("data",arr);
					request.setAttribute("data", al);
					//System.out.print(al);
	
				
				  
				  
			 }
			 catch(Exception e)
			 {
				 e.printStackTrace();
			 }
		%>
		
	<script>
	    var hash= "<%out.print(hash);%>"
		console.log(hash);

		function loadAjax1()
		{
       
        var url="LinkData?search="+hash;

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
                var rowshtml = '<tbody><tr> <th> Hospital ID </th> <th> Hospital Name </th> <th> Location </th> <th> Normal Beds </th> <th> Oxygen Beds </th> <th> ICU Beds </th> </tr>';
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
		
            

           
    
	//loadAjax1();
	//setInterval(loadAjax1,10000);
	</script>	
		
			
		
	</body>
	
</html>