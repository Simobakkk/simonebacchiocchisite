import java.io.*;
import java.net.*;

public class TcpServerB2 {

    private static final int PORT = 2223;

    public static void main(String[] args) {
        try (ServerSocket serverSocket = new ServerSocket(PORT)) { // non necessario specificare IP: server in ascolto su tutte le interfacce 
            System.out.println("Server TCP avviato sulla porta " + PORT);

            while (true) {
                Socket clientSocket = serverSocket.accept();
                System.out.println("Client connesso: " + clientSocket.getRemoteSocketAddress());

                // Crea un Runnable per gestire il client
                Runnable clientHandler = new ClientHandler(clientSocket);
                new Thread(clientHandler).start();
            }
        } catch (IOException e) {
            System.err.println("Errore server: " + e.getMessage());
        }
    }
    
    private static class ClientHandler implements Runnable {

        private Socket clientSocket;

        public ClientHandler(Socket clientSocket) {
            this.clientSocket = clientSocket;
        }

        @Override
        public void run() {

            try (
                BufferedReader in = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
                PrintWriter out = new PrintWriter(clientSocket.getOutputStream(), true)
            ) {

                String inputLine;

                while ((inputLine = in.readLine()) != null) {

                    double num1 = 0, num2 = 0;

                    if (inputLine.equalsIgnoreCase("quit")) {
                        continue;
                    }

                    String[] sintassi = inputLine.split(" ");
                    boolean idoneo = false;

                    if (sintassi.length != 3) {
                        out.println("Formato non valido");
                        continue;
                    } else {
                        try {
                            num1 = Double.parseDouble(sintassi[0]);
                            num2 = Double.parseDouble(sintassi[2]);
                            idoneo = true;
                        } catch (NumberFormatException e) {
                            out.println("ERRORE Formato non valido. Usa NUMERO OPERAZIONE NUMERO");
                            idoneo = false;
                            continue;
                        }
                    }

                    String operazione = sintassi[1];
                    double risultato = 0;

                    if (idoneo) {
                        try {
                            switch (operazione) {
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

                    out.println("Risultato: " + risultato);
                }

            } catch (IOException e) {
                System.out.println("ERRORE " + e.getMessage());
            } finally {
                try {
                    clientSocket.close();
                } catch (IOException ignored) {}
            }
        }
    }
}
