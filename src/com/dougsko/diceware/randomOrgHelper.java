package com.dougsko.diceware;

import java.io.ByteArrayOutputStream;
import java.io.IOException;

import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.StatusLine;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;

public class randomOrgHelper {
	randomOrgHelper(){}

	public static String getNumbers(){
		String url = "http://www.random.org/integers/?num=5&min=1&max=6&col=1&base=10&format=plain&rnd=new";
		String responseString = null;
    	HttpClient httpclient = new DefaultHttpClient();
        HttpResponse response = null;
        
        HttpGet request = new HttpGet(url);
        request.setHeader("User-Agent", "Android Diceware Application / dougtko@gmail.com");
		try {
			response = httpclient.execute(request);
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
        StatusLine statusLine = response.getStatusLine();
        if(statusLine.getStatusCode() == HttpStatus.SC_OK){
            ByteArrayOutputStream out = new ByteArrayOutputStream();
            try {
				response.getEntity().writeTo(out);
			} catch (IOException e) {
				e.printStackTrace();
			}
            try {
				out.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
			
            responseString = out.toString().replace("\n", "");
            
        } else{
            //Closes the connection.
            try {
				response.getEntity().getContent().close();
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
            try {
				throw new IOException(statusLine.getReasonPhrase());
			} catch (IOException e) {
				e.printStackTrace();
			}
        }
		return responseString;
	}
}
