package com.nox.myapplication;

import java.io.OutputStream;
import android.util.Log;

public class ProcessingData{
	
    private OutputStream outStream;
	private static final UUID MY_UUID

	public ProcessingData(OutputStream outStream,UUID MY_UUID){ {
			this.outStream=outStream;
			this.MY_UUID=MY_UUID;
	 }



	public void sendData(String message) {
			byte[] msgBuffer = message.getBytes();

			Log.d(TAG, "...Посылаем данные: " + message + "...");

			try {
				outStream.write(msgBuffer);
			} catch (IOException e) {
				String msg = "In onResume() and an exception occurred during write: " + e.getMessage();
				if (address.equals("00:00:00:00:00:00"))
					msg = msg + ".\n\nВ переменной address у вас прописан 00:00:00:00:00:00, вам необходимо прописать реальный MAC-адрес Bluetooth модуля";
					msg = msg + ".\n\nПроверьте поддержку SPP UUID: " + MY_UUID.toString() + " на Bluetooth модуле, к которому вы подключаетесь.\n\n";

				errorExit("Fatal Error", msg);
			}
		}
}