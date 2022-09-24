import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServlet;
import javax.servlet.*;
import org.json.JSONObject;
import java.security.*;
import java.math.*;
import java.text.SimpleDateFormat;
import java.util.Date;

public class GenerateLink extends HttpServlet {
	public String generateLink(HttpServletRequest request) {
		String url = "";
		String hash = "";
		try {
			SimpleDateFormat date = new SimpleDateFormat("yyyy.MM.dd.HH:mm:ss");
			String timeStamp = date.format(new Date());
			timeStamp = timeStamp + "Ur@#$1123";
			// System.out.println(timeStamp);

			MessageDigest m = MessageDigest.getInstance("SHA-256");
			m.update(timeStamp.getBytes(), 0, timeStamp.length());
			hash = new BigInteger(1, m.digest()).toString(16);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return hash;

	}

	public String getRequestBody(HttpServletRequest request, HttpServletResponse response) {
		String texts = "";
		try {
			ServletInputStream mServletInputStream = request.getInputStream();
			byte[] httpinData = new byte[request.getContentLength()];
			int retVal = -1;

			StringBuilder stringBuilder = new StringBuilder();

			while ((retVal = mServletInputStream.read(httpinData)) != -1) {
				for (int i = 0; i < retVal; i++) {
					stringBuilder.append(Character.toString((char) httpinData[i]));
				}
			}

			texts = stringBuilder.toString();

		} catch (Exception e) {
			e.printStackTrace();
		}
		return texts;

	}

	public int checkAvailabilty(String name, String location, String nbed, String obed, String ibed, String cond1,
			String cond2, String cond3) {
		int check = 0;
		try {
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost/covid", "root", "Gokul@2001");
			Statement st1 = con.createStatement();
			String sql = "select hospitals.hospital_id,hospital_information.Hospital_Name,hospitals.location,hospital_information.normal_bed,hospital_information.oxygen_bed,hospital_information.icu_bed FROM hospitals INNER JOIN hospital_information ON hospitals.hospital_id=hospital_information.hospital_id where hospitals.Hospital_Name LIKE '"
					+ name + "'and hospitals.location= '" + location + "'and hospital_information.normal_bed" + cond1
					+ "'" + nbed + "' and hospital_information.oxygen_bed" + cond2 + "'" + obed
					+ "'and hospital_information.icu_bed" + cond3 + "'" + ibed + "'";
			ResultSet rs1 = st1.executeQuery(sql);
			if (rs1.next())
				check = 1;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return check;
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			String texts = getRequestBody(request, response);

			String hash = generateLink(request);

			String[] loca = ((request.getRequestURL()).toString()).split("/");
			String url = "http://" + loca[2] + "/CBA/report" + hash;

			System.out.println(url);
			System.out.println(hash);

			JSONObject js = new JSONObject(texts);
			JSONObject js1 = js.getJSONObject("payload");
			JSONObject js2 = js1.getJSONObject("parsed");

			String name = js2.getString("Name");
			String location = js2.getString("Location");
			String nbed = js2.getString("Normal Beds");
			String obed = js2.getString("Oxygen Beds");
			String ibed = js2.getString("ICU Beds");

			String cond1 = js2.getString("cond1");
			String cond2 = js2.getString("cond2");
			String cond3 = js2.getString("cond3");

			int check = checkAvailabilty(name, location, nbed, obed, ibed, cond1, cond2, cond3);

			String query = "insert into url2(hash,name,location,nbed,obed,ibed,cond1,cond2,cond3) values(?,?,?,?,?,?,?,?,?)";
			ArrayList<String> list = new ArrayList<String>() {
				{
					add(hash);
					add(name);
					add(location);
					add(nbed);
					add(obed);
					add(ibed);
					add(cond1);
					add(cond2);
					add(cond3);
				}
			};

			DbHelper.insertPS(query, list);

			response.getWriter().write(url);

		} catch (Exception e) {
			e.printStackTrace();
		}

	}
}