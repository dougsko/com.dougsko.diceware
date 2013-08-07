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

import android.content.Context;

public class randomOrgHelper {
	randomOrgHelper(Context context){
	}

	public String getNumbers(){
		String url = "https://www.random.org/integers/?num=5&min=1&max=6&col=1&base=10&format=plain&rnd=new";
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
			return null;
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
	
	/*
	public static String getNumbersSSL() {
		KeyStore keyStore = Diceware.keyStore();
		KeyManagerFactory kmf = null;
		try {
			kmf = KeyManagerFactory.getInstance("X509");
		} catch (NoSuchAlgorithmException e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
		
		
		String responseString = null;
		HttpsURLConnection urlConnection = null;
		URL url = null;
		SSLContext context = null;
		try {
			context = SSLContext.getInstance("TLS");
		} catch (NoSuchAlgorithmException e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
		try {
			context.init(kmf.getKeyManagers(), null, null);
		} catch (KeyManagementException e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}

		try {
			url = new URL("http://www.random.org/integers/?num=5&min=1&max=6&col=1&base=10&format=plain&rnd=new");
		} catch (MalformedURLException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		try {
			urlConnection = (HttpsURLConnection) url.openConnection();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//urlConnection.setSSLSocketFactory(context.getSocketFactory());
		try {
			InputStream in = urlConnection.getInputStream();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
				
		return responseString;
		
	}
	*/
}
