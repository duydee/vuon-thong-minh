package com.example.appvuonthongminh;

import android.app.ListFragment;
import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.List;

import io.socket.emitter.Emitter;


public class ListFlagmentControlCot2 extends ListFragment  {
    ArrayList<ControlTB> controlTBArrayList;
    ArrayList<ControlTB> controlTBArrayList2;
    ControlTBAdapter controlTBAdapter;
    int idflag = 0;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        controlTBArrayList = new ArrayList<>();
        controlTBArrayList2 = new ArrayList<>();

        controlTBAdapter = new ControlTBAdapter((MainActivity) getActivity(),R.layout.dong_control_cot2, controlTBArrayList);
        setListAdapter(controlTBAdapter);

        return inflater.inflate(R.layout.listflagment,container,false);
    }

    void flagControl(int idFlag)
    {
        idflag = idFlag;
        if(controlTBArrayList.isEmpty())
        {
            Toast.makeText(getActivity(), "Không kết nối được đến Server", Toast.LENGTH_SHORT).show();
        }
        else {
            ganData();
        }
    }

    void ganData()
    {
        controlTBArrayList.clear();
        switch (idflag)
        {
            case 0:  //sensor
                for(int i=0;i<=3;i++)
                {
                    controlTBArrayList.add(controlTBArrayList2.get(i));
                }
                break;
            case 1:  //den
                for(int i=4;i<=6;i++)
                {
                    controlTBArrayList.add(controlTBArrayList2.get(i));
                }
                break;
            case 2:   //quat
                for(int i=7;i<=9;i++)
                {
                    controlTBArrayList.add(controlTBArrayList2.get(i));
                }
                break;
            case 3:  //bom
                for(int i=10;i<=12;i++)
                {
                    controlTBArrayList.add(controlTBArrayList2.get(i));
                }
                break;
            case 4:   //relay
                for(int i=13;i<=20;i++)
                {
                    controlTBArrayList.add(controlTBArrayList2.get(i));
                }
                break;
        }
        controlTBAdapter.notifyDataSetChanged();
    }

    public void getDataControl(JSONArray data)
    {
        try {
            controlTBArrayList2.clear();
            for(int i=0;i<data.length();i++)
            {
                JSONObject object = data.getJSONObject(i);
                controlTBArrayList2.add(new ControlTB(
                                object.getInt("id"),
                                object.getString("ten"),
                                object.getString("trangthai"))
                );
            }
            ganData();
        } catch (JSONException e) {
            e.printStackTrace();
        }

       // Toast.makeText(getActivity(), controlTBArrayList.get(0).getTenTB(), Toast.LENGTH_SHORT).show();
    }

    public void capnhapDataControl(JSONObject data)
    {
        try {
            controlTBArrayList2.get(data.getInt("id")).setTrangthai(data.getString("trangthai"));
            controlTBAdapter.notifyDataSetChanged();
        } catch (JSONException e) {
            e.printStackTrace();
        }
       // Toast.makeText(getActivity(), data.toString(), Toast.LENGTH_SHORT).show();
    }

}
