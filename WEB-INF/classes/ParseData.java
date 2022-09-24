import java.sql.SQLException;

import org.json.*;

public class ParseData {
    public static void getData(Object o) throws JSONException, SQLException {
        int error = 0;
        String[] arr = o.toString().split("\\r?\\n");
        JSONObject ob = new JSONObject();

        for (int s = 0; s < arr.length && s < 5; s++) {
            if (s == 0 || s == 1) {
                if (arr[s].contains(":")) {
                    String[] arr1 = arr[s].split(":");
                    arr1[0] = arr1[0].trim().toLowerCase();
                    arr1[1] = arr1[1].trim();

                    if (arr1[0].equals("name"))
                        ob.put("Name", arr1[1]);
                    else if (arr1[0].equals("location"))
                        ob.put("Location", arr1[1]);
                } else {
                    error = 1;
                }
            } else {
                if (arr[s].contains(">")) {
                    String[] arr2 = arr[s].split(">");
                    arr2[0] = arr2[0].trim().replace(" ", "").toLowerCase();
                    arr2[1] = arr2[1].trim();

                    if (arr2[0].equals("normalbeds")) {
                        ob.put("Normal Beds", arr2[1]);
                        ob.put("cond1", ">");
                    } else if (arr2[0].equals("oxygenbeds")) {
                        ob.put("Oxygen Beds", arr2[1]);
                        ob.put("cond2", ">");
                    } else if (arr2[0].equals("icubeds")) {
                        ob.put("ICU Beds", arr2[1]);
                        ob.put("cond3", ">");
                    }

                } else if (arr[s].contains("<")) {
                    String[] arr3 = arr[s].split("<");
                    arr3[0] = arr3[0].trim().replace(" ", "").toLowerCase();
                    arr3[1] = arr3[1].trim();

                    if (arr3[0].equals("normalbeds")) {
                        ob.put("Normal Beds", arr3[1]);
                        ob.put("cond1", ">");
                    } else if (arr3[0].equals("oxygenbeds")) {
                        ob.put("Oxygen Beds", arr3[1]);
                        ob.put("cond2", ">");
                    } else if (arr3[0].equals("icubeds")) {
                        ob.put("ICU Beds", arr3[1]);
                        ob.put("cond3", ">");
                    }
                } else {
                    error = 1;
                }
            }

        }

        if (error == 1) {
            CheckMails.receiveUrl("", 0);
        } else {
            CreateLink.getJSON(ob);
        }

    }

}
