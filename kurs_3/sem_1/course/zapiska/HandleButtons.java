package com.nox.myapplication;

import android.view.MotionEvent;
import android.view.View;
import android.widget.Button;

public class HandleButtons implements View.OnTouchListener {

    Button btnTake, btnBreak, btnRight, btnLeft,
            btnUp, btnDown, btnForward, btnBack;

    ProcessingData PD;


    public HandleButtons(ProcessingData PD, Button btnBack, 
							Button btnForward, Button btnBreak, Button btnTake, 
							Button btnDown, Button btnUp, Button btnLeft, 
							Button btnRight) {
        this.btnBack = btnBack;
        this.btnForward = btnForward;
        this.btnBreak = btnBreak;
        this.btnTake = btnTake;
        this.btnDown = btnDown;
        this.btnUp = btnUp;
        this.btnLeft = btnLeft;
        this.btnRight = btnRight;
        this.PD = PD;
    }


    void createButtonsHandlers() {
        btnDown.setOnTouchListener(this);
        btnUp.setOnTouchListener(this);
        btnLeft.setOnTouchListener(this);
        btnRight.setOnTouchListener(this);
        btnTake.setOnTouchListener(this);
        btnBreak.setOnTouchListener(this);
        btnForward.setOnTouchListener(this);
        btnBack.setOnTouchListener(this);
    }

    @Override
    public boolean onTouch(View v, MotionEvent event) {
        int answer = 0;
        switch (v.getId()) {
            case R.id.btnLeft:
                answer = 102;
                break;
            case R.id.btnRight:
                answer = 101;
                break;
            case R.id.buttonBack:
                answer = 103;
                break;
            case R.id.buttonForward:
                answer = 104;
                break;
            case R.id.buttonBreak:
                answer = 97;
                break;
            case R.id.buttonTake:
                answer = 98;
                break;
            case R.id.buttonUp:
                answer = 100;
                break;
            case R.id.buttonDown:
                answer = 99;
                break;
        }
        switch (event.getAction()) {
            case MotionEvent.ACTION_DOWN: // нажатие
                answer -= 32;
                PD.sendData(Character.toString((char) answer));
                break;
            case MotionEvent.ACTION_UP: // отпускание
            case MotionEvent.ACTION_CANCEL:
                PD.sendData(Character.toString((char) answer));
                break;
        }
        return false;
    }
}
