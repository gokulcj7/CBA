function add_hos(){
	var x=document.getElementById("btn1");
	x.style.display="none";
	html='<div id="dform">\<form action="Insert" method="post">\
	<input type="text" name="iid" placeholder="Hospital ID">\
	<input type="text" name="name" placeholder="Hospital Name">\
	<input type="text" name="location" placeholder="Location">\
	<input type="text" name="nbed" placeholder="Normal Bed">\
	<input type="text" name="obed" placeholder="Oxygen Bed">\
	<input type="text" name="ibed" placeholder="ICU Bed">\
	<button onclick="dis()">submit</button>\
	</form>\
	</div>'
	var ip=document.getElementById('ip')
	ip.innerHTML+=html;
}

function dis(){
	var x=document.getElementById("btn1");
	var r=document.getElementById("dform");
	r.style.display="none";
	x.style.display="block";
}

function loc(){
	html='<div id="dform1">\<form action="Selectall" method="post">\
	<input type="text" name="nloc" placeholder="Location">\
	<button onclick="hide()">submit</button>\
	</form>\
	</div>'
	console.log("hello");
	var ip=document.getElementById('temp');
	ip.innerHTML+=html;
}

function hide(){
	var x=document.getElementById("dform1");
	x.style.display="none";
}

var request1;  
function sendInfo1()  
{  
	
	var id=document.getElementById("id"); 
	var name=document.getElementById("name");
	var location=document.getElementById("location");
	var nbed=document.getElementById("nbed");
	var obed=document.getElementById("obed");
	var ibed=document.getElementById("ibed"); 
	var url="Update.jsp?id="+id+"&name="+name+"&location="+location+"&nbed="+nbed+"&obed="+obed+"&ibed="+ibed;  
	
	request1=new XMLHttpRequest();  

 
  
	try{  
	request1.onreadystatechange=getInfo1;  
	request1.open("POST",url,true);  
	request1.send();  
	}catch(e){alert("Unable to connect to server");}  
}  
  
function getInfo1(){  
if(request1.readyState==4){  
var val=request1.responseText;  
document.getElementById('temp').innerHTML=val;  
}  
} 


var request2;
function sendInfo2()  
{  
	
	var id=document.getElementById("sid");  
	var url="Delete.jsp?id="+id;  
	
	request2=new XMLHttpRequest();  

 
  
	try{  
	request2.onreadystatechange=getInfo2;  
	request2.open("POST",url,true);  
	request2.send();  
	}catch(e){alert("Unable to connect to server");}  
}  
  
function getInfo2(){  
if(request2.readyState==4){  
var val=request2.responseText;  
document.getElementById('temp').innerHTML=val;  
}  
}

 












	
		
  
	
	
