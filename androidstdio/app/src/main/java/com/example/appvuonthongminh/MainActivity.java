package com.example.appvuonthongminh;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.app.AlertDialog;
import android.app.Dialog;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.app.ListFragment;
import android.content.DialogInterface;
import android.graphics.Color;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.Window;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.net.URISyntaxException;

import io.socket.client.IO;
import io.socket.client.Socket;
import io.socket.emitter.Emitter;

public class MainActivity extends AppCompatActivity {
    TextView txtNhietDo,txtDoAm,txtDoAmDat;
    ImageView imgIconThoiTiet;

    Button btnControlTB,btnHenGioTB;

    FragmentManager fragmentManager = getFragmentManager();

    String flagData = "0";  // flag dung de danh dau chuyen data cho layout
    int temp;

    int flagAutoDen=0,flagAutoQuat=0,flagAutoBom=0;

    private Socket msocket;
    {
        try {
            //msocket = IO.socket("https://vuonthongminh.herokuapp.com/");
            msocket = IO.socket("http://192.168.0.137:8080/");
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }
    }
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        anhxa();

        msocket.connect();

        msocket.on("capnhapdataSensor",nhanDataSensor);

        msocket.on("dongboallDataStatusTB",nhanDataControl);

        msocket.on("dongboallDataHengioTB",nhanDataHengio);

        msocket.on("capnhapdataStatusTB",capnhapStatusTB);

        msocket.on("capnhapdataHenGioOnTB",capnhapHenGioOnTB);

        msocket.on("capnhapdataHenGioOffTB",capnhapHenGioOffTB);

        msocket.on("capnhapDeleteHengioTB",capnhapDeleteHenGioTB);

        msocket.on("capnhapDataAutoDen",capnhapDataAutoTbDen);
        msocket.on("capnhapDataAutoQuat",capnhapDataAutoTbQuat);
        msocket.on("capnhapDataAutoBom",capnhapDataAutoTbBom);
    }

    void anhxa()
    {
        txtNhietDo = (TextView) findViewById(R.id.textViewNhietDo);
        txtDoAm = (TextView) findViewById(R.id.textViewDoAm);
        txtDoAmDat = (TextView) findViewById(R.id.textViewDoAmDat);
        imgIconThoiTiet = (ImageView) findViewById(R.id.imageViewIconThoiTiet);

        btnControlTB = (Button) findViewById(R.id.buttonControlTb);
        btnHenGioTB = (Button) findViewById(R.id.buttonHenGioTb);

        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
        fragmentTransaction.replace(R.id.layoutCot1,new ListFlagmentControlCot1());
        fragmentTransaction.replace(R.id.layoutCot2,new ListFlagmentControlCot2());
        fragmentTransaction.commit();
        msocket.emit("dongboDataControlTB","");
        //set hieu ung button
        btnControlTB.setBackgroundColor(Color.GRAY);
        btnControlTB.setTextColor(Color.BLACK);
    }

    public void LayoutChange(View view)
    {
        ListFragment cot1 = null;
        ListFragment cot2 = null;
        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
        switch (view.getId())
        {
            case R.id.buttonControlTb:
                cot1 = new ListFlagmentControlCot1();
                cot2 = new ListFlagmentControlCot2();
                flagData = "0";
                msocket.emit("dongboDataControlTB","");

                //set hieu ung button
                btnControlTB.setBackgroundColor(Color.GRAY);
                btnControlTB.setTextColor(Color.BLACK);
                btnHenGioTB.setBackgroundColor(Color.BLACK);
                btnHenGioTB.setTextColor(Color.WHITE);
                break;
            case R.id.buttonHenGioTb:
                cot1 = new ListFlagmentHenGioCot1();
                cot2 = new ListFlagmentHenGioCot2();
                flagData = "1";
                msocket.emit("dongboDataHengioTB","");

                //set hieu ung button
                btnControlTB.setBackgroundColor(Color.BLACK);
                btnControlTB.setTextColor(Color.WHITE);
                btnHenGioTB.setBackgroundColor(Color.GRAY);
                btnHenGioTB.setTextColor(Color.BLACK);
                break;
        }
        fragmentTransaction.replace(R.id.layoutCot1,cot1);
        fragmentTransaction.replace(R.id.layoutCot2,cot2);
        fragmentTransaction.commit();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.my_menu,menu);
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(@NonNull MenuItem item) {
        switch (item.getItemId())
        {
            case R.id.menu_Bieu_do:
                break;
            case R.id.menu_modeAuto:
                DialogModeAuto(flagAutoDen,flagAutoQuat,flagAutoBom);
                break;
            case R.id.menu_setting:
                break;
        }
        return super.onOptionsItemSelected(item);
    }

    public Emitter.Listener nhanDataSensor = new Emitter.Listener() {
        @Override
        public void call(Object... args) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    JSONArray array  = (JSONArray) args[0];
                    try {
                        JSONObject object = array.getJSONObject(0);
                        txtNhietDo.setText(object.getString("temp"));
                        txtDoAm.setText(object.getString("humi"));
                        txtDoAmDat.setText(object.getString("doamdat"));
                        temp = Integer.parseInt(object.getString("temp"));
                        if(object.getString("cambienmua").equals("1"))
                        {
                            imgIconThoiTiet.setImageDrawable(getResources().getDrawable(R.drawable.rain));
                        }
                        else if(temp >= 38)
                        {
                            imgIconThoiTiet.setImageDrawable(getResources().getDrawable(R.drawable.sun));
                        }
                        else
                        {
                            imgIconThoiTiet.setImageDrawable(getResources().getDrawable(R.drawable.cloud));
                        }
//                        Toast.makeText(MainActivity.this, object.toString(), Toast.LENGTH_SHORT).show();
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                }
            });
        }
    };

    public Emitter.Listener nhanDataControl = new Emitter.Listener() {
        @Override
        public void call(Object... args) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    JSONArray array  = (JSONArray) args[0];
                    if(flagData.equals("0"))  // data cho layout control
                    {
                        ListFlagmentControlCot2 listFlagmentControlCot2 = (ListFlagmentControlCot2) getFragmentManager().findFragmentById(R.id.layoutCot2);
                        listFlagmentControlCot2.getDataControl(array);
                    }
                }
            });
        }
    };

    public Emitter.Listener nhanDataHengio = new Emitter.Listener() {
        @Override
        public void call(Object... args) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    JSONArray array  = (JSONArray) args[0];
                    if(flagData.equals("1"))  // data cho layout hen gio
                    {
                        ListFlagmentHenGioCot2 listFlagmentHenGioCot2 = (ListFlagmentHenGioCot2) getFragmentManager().findFragmentById(R.id.layoutCot2);
                        listFlagmentHenGioCot2.getDataHengio(array);
                    }
                }
            });
        }
    };

    public Emitter.Listener capnhapStatusTB = new Emitter.Listener() {
        @Override
        public void call(Object... args) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    JSONObject object  = (JSONObject) args[0];
                    if(flagData.equals("0"))  // data cho layout control
                    {
                        ListFlagmentControlCot2 listFlagmentControlCot2 = (ListFlagmentControlCot2) getFragmentManager().findFragmentById(R.id.layoutCot2);
                        listFlagmentControlCot2.capnhapDataControl(object);
                    }
                }
            });
        }
    };

    public Emitter.Listener capnhapHenGioOnTB = new Emitter.Listener() {
        @Override
        public void call(Object... args) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    JSONObject object  = (JSONObject) args[0];
                    if(flagData.equals("1"))  // data cho layout hen gio
                    {
                        ListFlagmentHenGioCot2 listFlagmentHenGioCot2 = (ListFlagmentHenGioCot2) getFragmentManager().findFragmentById(R.id.layoutCot2);
                        listFlagmentHenGioCot2.capnhapDataHenGioOn(object);
                    }
                }
            });
        }
    };

    public Emitter.Listener capnhapHenGioOffTB = new Emitter.Listener() {
        @Override
        public void call(Object... args) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    JSONObject object  = (JSONObject) args[0];
                    if(flagData.equals("1"))  // data cho layout hen gio
                    {
                        ListFlagmentHenGioCot2 listFlagmentHenGioCot2 = (ListFlagmentHenGioCot2) getFragmentManager().findFragmentById(R.id.layoutCot2);
                        listFlagmentHenGioCot2.capnhapDataHenGioOff(object);
                    }
                }
            });
        }
    };

    public Emitter.Listener capnhapDeleteHenGioTB = new Emitter.Listener() {
        @Override
        public void call(Object... args) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    JSONObject object  = (JSONObject) args[0];
                    if(flagData.equals("1"))  // data cho layout hen gio
                    {
                        ListFlagmentHenGioCot2 listFlagmentHenGioCot2 = (ListFlagmentHenGioCot2) getFragmentManager().findFragmentById(R.id.layoutCot2);
                        listFlagmentHenGioCot2.capnhapDeleteHenGioTB(object);
                    }
                }
            });
        }
    };

    public Emitter.Listener capnhapDataAutoTbDen = new Emitter.Listener() {
        @Override
        public void call(Object... args) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    JSONObject object  = (JSONObject) args[0];
                    try {
                        flagAutoDen = object.getInt("trangthai");
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }
            });
        }
    };

    public Emitter.Listener capnhapDataAutoTbQuat = new Emitter.Listener() {
        @Override
        public void call(Object... args) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    JSONObject object  = (JSONObject) args[0];
                    try {
                        flagAutoQuat = object.getInt("trangthai");
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }
            });
        }
    };

    public Emitter.Listener capnhapDataAutoTbBom = new Emitter.Listener() {
        @Override
        public void call(Object... args) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    JSONObject object  = (JSONObject) args[0];
                    try {
                        flagAutoBom = object.getInt("trangthai");
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }
            });
        }
    };

    public void updatedataStatusTB(ControlTB tb)
    {
        JSONObject object  = new JSONObject();
        try {
            object.put("id",tb.id);
            object.put("trangthai",tb.trangthai);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        msocket.emit("updatedataStatusTB",object);
    }

    public void updatedataHenGioOnTB(int id ,String GioOn,String PhutOn)
    {
        JSONObject object  = new JSONObject();
        try {
            object.put("id",id);
            object.put("gioON",GioOn);
            object.put("phutON",PhutOn);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        msocket.emit("updatedataHenGioOnTB",object);
    }

    public void updatedataHenGioOffTB(int id ,String GioOff,String PhutOff)
    {
        JSONObject object  = new JSONObject();
        try {
            object.put("id",id);
            object.put("gioOFF",GioOff);
            object.put("phutOFF",PhutOff);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        msocket.emit("updatedataHenGioOffTB",object);
    }

    public void deleteHengio(int id)
    {
        JSONObject object  = new JSONObject();
        try {
            object.put("id",id);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        msocket.emit("deleteHengio",object);
    }

    public void DialogSuaHengioOn(HenGioTB tb)
    {
        Dialog dialog = new Dialog(MainActivity.this);
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dialog.setContentView(R.layout.dialog_sua_hengiotb);

        TextView title = (TextView) dialog.findViewById(R.id.textViewTitleSuaHengioTB);
        TextView trangthaiHG = (TextView) dialog.findViewById(R.id.txtTrangThaiHengioTB);
        EditText edtGioOn = (EditText) dialog.findViewById(R.id.editTextGioHengioTB);
        EditText edtPhutOn = (EditText) dialog.findViewById(R.id.editTextPhutHengioTB);

        Button btnSua = (Button) dialog.findViewById(R.id.buttonSuaDiglogHengioTb);
        Button btnHuy = (Button) dialog.findViewById(R.id.buttonHuyDiglogHengioTb);

        title.setText(tb.tenTB);
        trangthaiHG.setText("ON");
        edtGioOn.setText(tb.GioOn);
        edtPhutOn.setText(tb.PhutOn);


        btnHuy.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialog.dismiss();
            }
        });
        btnSua.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String GioOn = edtGioOn.getText().toString();
                String PhutOn = edtPhutOn.getText().toString();

                if(GioOn.equals("") | PhutOn.equals("") )
                {
                    Toast.makeText(MainActivity.this, "Vui lòng nhập đầy đủ!!!", Toast.LENGTH_SHORT).show();
                }
                else
                {
                    //Hẹn giờ ON
                    updatedataHenGioOnTB(tb.id,GioOn,PhutOn);
                    Toast.makeText(MainActivity.this, "Sửa thành công", Toast.LENGTH_SHORT).show();
                    dialog.dismiss();
                }
            }
        });
        dialog.show();
    }

    public void DialogSuaHengioOff(HenGioTB tb)
    {
        Dialog dialog = new Dialog(MainActivity.this);
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dialog.setContentView(R.layout.dialog_sua_hengiotb);

        TextView title = (TextView) dialog.findViewById(R.id.textViewTitleSuaHengioTB);
        TextView trangthaiHG = (TextView) dialog.findViewById(R.id.txtTrangThaiHengioTB);
        EditText edtGioOff = (EditText) dialog.findViewById(R.id.editTextGioHengioTB);
        EditText edtPhutOff = (EditText) dialog.findViewById(R.id.editTextPhutHengioTB);
        Button btnSua = (Button) dialog.findViewById(R.id.buttonSuaDiglogHengioTb);
        Button btnHuy = (Button) dialog.findViewById(R.id.buttonHuyDiglogHengioTb);

        title.setText(tb.tenTB);
        trangthaiHG.setText("OFF");
        edtGioOff.setText(tb.GioOff);
        edtPhutOff.setText(tb.phutOff);

        btnHuy.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialog.dismiss();
            }
        });
        btnSua.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String GioOff = edtGioOff.getText().toString();
                String PhutOff = edtPhutOff.getText().toString();
                if(GioOff.equals("") | PhutOff.equals(""))
                {
                    Toast.makeText(MainActivity.this, "Vui lòng nhập đầy đủ!!!", Toast.LENGTH_SHORT).show();
                }
                else
                {
                    //Hẹn giờ OFF
                    updatedataHenGioOffTB(tb.id,GioOff,PhutOff);
                    Toast.makeText(MainActivity.this, "Sửa thành công", Toast.LENGTH_SHORT).show();
                    dialog.dismiss();
                }
            }
        });
        dialog.show();
    }

    public void DialogXoaThietBi(int id, String ten)
    {
        AlertDialog.Builder builder = new AlertDialog.Builder(MainActivity.this);
        builder.setMessage("Xoá Hẹn giờ " + ten);
        builder.setPositiveButton("Có", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                deleteHengio(id);
                Toast.makeText(MainActivity.this, "Xoá thành công!", Toast.LENGTH_SHORT).show();
            }
        });

        builder.setNegativeButton("Không", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
            }
        });
        builder.show();
    }

    public void DialogModeAuto(int flagautoDen,int flagautoQuat,int flagautoBom)
    {
        Dialog dialog = new Dialog(MainActivity.this);
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dialog.setContentView(R.layout.dialog_modeauto);

        Switch swAutoDen = (Switch) dialog.findViewById(R.id.switchDialogAutoDen);
        Switch swAutoQuat = (Switch) dialog.findViewById(R.id.switchDialogAutoQuat);
        Switch swAutoBom = (Switch) dialog.findViewById(R.id.switchDialogAutoBom);

        if(flagautoDen == 1) { swAutoDen.setChecked(true); }
        else { swAutoDen.setChecked(false); }
        if(flagautoQuat == 1) { swAutoQuat.setChecked(true); }
        else { swAutoQuat.setChecked(false); }
        if(flagautoBom == 1) { swAutoBom.setChecked(true); }
        else { swAutoBom.setChecked(false); }

        swAutoDen.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                JSONObject object  = new JSONObject();
                if(isChecked)
                {
                    try {
                        object.put("trangthai",1);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                    msocket.emit("updatedataAutoDen",object);
                }
                else
                {
                    try {
                        object.put("trangthai",0);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                    msocket.emit("updatedataAutoDen",object);
                }
            }
        });

        swAutoQuat.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                JSONObject object  = new JSONObject();
                if(isChecked)
                {
                    try {
                        object.put("trangthai",1);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                    msocket.emit("updatedataAutoQuat",object);
                }
                else
                {
                    try {
                        object.put("trangthai",0);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                    msocket.emit("updatedataAutoQuat",object);
                }
            }
        });

        swAutoBom.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                JSONObject object  = new JSONObject();
                if(isChecked)
                {
                    try {
                        object.put("trangthai",1);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                    msocket.emit("updatedataAutoBom",object);
                }
                else
                {
                    try {
                        object.put("trangthai",0);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                    msocket.emit("updatedataAutoBom",object);
                }
            }
        });

        dialog.show();
    }
}