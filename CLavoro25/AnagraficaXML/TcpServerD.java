/**
 * from network/..
 * javac network/TcpServer.java; java network.TcpServer 
 */

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.net.ServerSocket;
import java.net.Socket;

public class TcpServerD {
	public static void main(String[] args) throws Exception {
		
		int severPort=7774;
		String clientMsg = "";
		
		try {			 
			// Creazione del socket sul server e ascolto sulla porta
			ServerSocket serverSocket = new ServerSocket(severPort);
			System.out.println("Server: in ascolto sulla porta " + severPort);

			// Attesa della connessione con il client
			Socket clientSocket = serverSocket.accept();
			
			// Create input and output streams to read/write data
			DataInputStream inStream = new DataInputStream(clientSocket.getInputStream());
			DataOutputStream outStream = new DataOutputStream(clientSocket.getOutputStream());	

			// Scambio di dati tra client e server
			while(!clientMsg.equalsIgnoreCase("quit")) {
				//Lettura dato da stream di rete
				clientMsg = inStream.readUTF();
				clientMsg = clientMsg.trim();
				String[] sintassi = clientMsg.split(" ");

				double num1=0, num2=0;
                //verifica richiesta di chiusura connessione
                if(clientMsg.equalsIgnoreCase("quit")){
                    continue;
                }
				boolean idoneo = false;
				if(sintassi.length!=3){
					outStream.writeUTF("Formato non valido");
					outStream.flush();
                    continue;
				}else{
					try {
                        num1 = Double.parseDouble(sintassi[0]);
                        num2 = Double.parseDouble(sintassi[2]);
						idoneo = true;
                    } catch (NumberFormatException e) {
                        outStream.writeUTF("ERRORE Formato non valido. Usa NUMERO OPERAZIONE NUMERO");
						outStream.flush();
						idoneo = false;
                    	continue;
                    }
				}
				String operazione = sintassi[1];
				double risultato=0;
				if(idoneo){
					try {
						switch(operazione){
						case "+" -> risultato = num1 + num2;
						case "-" -> risultato = num1 - num2;
						case "*" -> risultato = num1 * num2;
						case "/" -> risultato = num1 / num2;
					}
                    } catch (Exception ex) {
                    	System.out.println("ERRORE " + ex.getMessage());
                        continue;
                    }
				}
				outStream.writeUTF("Risultato: "+risultato);
				outStream.flush();

            }
			//chiusura risorse
			serverSocket.close();
			clientSocket.close();
			inStream.close();
			outStream.close();
		}
		catch (Exception e) {
			System.out.println(e);
		}
	}
}