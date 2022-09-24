import java.math.BigInteger;
import java.security.MessageDigest;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;

import org.json.JSONException;
import org.json.JSONObject;

public class CreateLink {
    public static void getJSON(JSONObject ob) throws JSONException, SQLException { // get Parameters from JSON

        String name = ob.getString("Name");
        String location = ob.getString("Location");
        String nbed = ob.getString("Normal Beds");
        String obed = ob.getString("Oxygen Beds");
        String ibed = ob.getString("ICU Beds");
        String cond1 = ob.getString("cond1");
        String cond2 = ob.getString("cond2");
        String cond3 = ob.getString("cond3");

        checkBeds(name, location, nbed, obed, ibed, cond1, cond2, cond3);

    }

    public static void checkBeds(String name, String location, String nbed, String obed, String ibed, String cond1,
            String cond2, String cond3) throws SQLException { // Check bed Availability in DB

        int check = 0;
        String sql = "select hospitals.hospital_id,hospital_information.Hospital_Name,hospitals.location,hospital_information.normal_bed,hospital_information.oxygen_bed,hospital_information.icu_bed FROM hospitals INNER JOIN hospital_information ON hospitals.hospital_id=hospital_information.hospital_id where hospitals.Hospital_Name LIKE '"
                + name + "'and hospitals.location= '" + location + "'and hospital_information.normal_bed" + cond1
                + "'" + nbed + "' and hospital_information.oxygen_bed" + cond2 + "'" + obed
                + "'and hospital_information.icu_bed" + cond3 + "'" + ibed + "'";
        ResultSet rs1 = DbHelper.GetResult(sql);
        if (rs1.next())
            check = 1;

        if (check == 1)
            createLink(name, location, nbed, obed, ibed, cond1, cond2, cond3);
        else
            CheckMails.receiveUrl("", 1);

    }

    public static String generateHash() { // Generate Hash for the link
        String hash = "";
        try {
            SimpleDateFormat date = new SimpleDateFormat("yyyy.MM.dd.HH:mm:ss");
            String timeStamp = date.format(new Date());
            timeStamp = timeStamp + "Ur@#$1123";

            MessageDigest m = MessageDigest.getInstance("SHA-256");
            m.update(timeStamp.getBytes(), 0, timeStamp.length());
            hash = new BigInteger(1, m.digest()).toString(16);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return hash;
    }

    public static String checkHash(String name, String location, String nbed, String obed, String ibed,
            String cond1, String cond2, String cond3) throws SQLException { // Check if any hash exists for the search
        System.out.println("Checking Hash");
        String hash = "";
        String query = "select hash from url2 where name='"
                + name + "'and location='" + location + "'and nbed='" + nbed + "'and obed='" + obed + "' and ibed='"
                + ibed + "' and cond1='" + cond1 + "' and cond2='" + cond2 + "' and cond3='" + cond3 + "'";
        ResultSet rs = DbHelper.GetResult(query);
        if (rs.next())
            hash = rs.getString(1);

        System.out.println(hash);

        return hash;
    }

    public static void insertHash(String hash, String name, String location, String nbed, String obed, String ibed,
            String cond1, String cond2, String cond3) throws SQLException { // Insert new hash if no hash exists

        String query = "insert into url2(hash,name,location,nbed,obed,ibed,cond1,cond2,cond3) values(?,?,?,?,?,?,?,?,?)";
        ArrayList<String> list = new ArrayList<String>();
        list.addAll(Arrays.asList(hash, name, location, nbed, obed, ibed, cond1, cond2, cond3));

        DbHelper.insertPS(query, list);

    }

    public static void createLink(String name, String location, String nbed, String obed, String ibed, String cond1,
            String cond2, String cond3) throws SQLException { // Create Link for the search result

        String chkhash = checkHash(name, location, nbed, obed, ibed, cond1, cond2, cond3);

        if (chkhash.length() < 1) {
            String hash = generateHash();
            String url = "http://localhost:8080/CBA/report/" + hash;

            insertHash(hash, name, location, nbed, obed, ibed, cond1, cond2, cond3);
            CheckMails.receiveUrl(url, 2);
        } else {
            String url = "http://localhost:8080/CBA/report/" + chkhash;
            CheckMails.receiveUrl(url, 2);
        }

    }

}
