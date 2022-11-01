package com.example.appvuonthongminh;

import android.app.ListFragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

public class ListFlagmentHenGioCot2 extends ListFragment {
    ArrayList<HenGioTB> henGioTBArrayList;
    ArrayList<HenGioTB> henGioTBArrayList2;
    HenGioTBAdapter henGioTBAdapter ;
    int idflag =0;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        henGioTBArrayList = new ArrayList<>();
        henGioTBArrayList2 = new ArrayList<>();

        henGioTBAdapter = new HenGioTBAdapter((MainActivity) getActivity(),R.layout.dong_hengio_cot2, henGioTBArrayList);
        setListAdapter(henGioTBAdapter);

        return inflater.inflate(R.layout.listflagment,container,false);
    }

    void flagHengio(int idFlag)
    {
        idflag = idFlag;
        if(henGioTBArrayList.isEmpty())
        {
            Toast.makeText(getActivity(), "Không kết nối được đến Server", Toast.LENGTH_SHORT).show();
        }
        else
        {
            ganData();
        }
    }

    void ganData()
    {
        henGioTBArrayList.clear();
        switch (idflag)
        {
            case 0:  //Đèn Khu 1
                for(int i=0;i<=2;i++)
                {
                    henGioTBArrayList.add(henGioTBArrayList2.get(i));
                }
                break;
            case 1: //Đèn Khu 2
                for(int i=3;i<=5;i++)
                {
                    henGioTBArrayList.add(henGioTBArrayList2.get(i));
                }
                break;
            case 2: //Đèn Khu 3
                for(int i=6;i<=8;i++)
                {
                    henGioTBArrayList.add(henGioTBArrayList2.get(i));
                }
                break;
            case 3: //Quạt Khu 1
                for(int i=9;i<=11;i++)
                {
                    henGioTBArrayList.add(henGioTBArrayList2.get(i));
                }
                break;
            case 4:  //Quạt Khu 2
                for(int i=12;i<=14;i++)
                {
                    henGioTBArrayList.add(henGioTBArrayList2.get(i));
                }
                break;
            case 5:  //Quạt Khu 3
                for(int i=15;i<=17;i++)
                {
                    henGioTBArrayList.add(henGioTBArrayList2.get(i));
                }
                break;
            case 6:  //Bơm Khu 1
                for(int i=18;i<=20;i++)
                {
                    henGioTBArrayList.add(henGioTBArrayList2.get(i));
                }
                break;
            case 7: //Bơm Khu 2
                for(int i=21;i<=23;i++)
                {
                    henGioTBArrayList.add(henGioTBArrayList2.get(i));
                }
                break;
            case 8:  //Bơm Khu 3
                for(int i=24;i<=26;i++)
                {
                    henGioTBArrayList.add(henGioTBArrayList2.get(i));
                }
                break;
        }
        henGioTBAdapter.notifyDataSetChanged();
    }

    void getDataHengio(JSONArray data)
    {
        try {
            henGioTBArrayList2.clear();
            for(int i=0;i<data.length();i++)
            {
                JSONObject object = data.getJSONObject(i);
                henGioTBArrayList2.add(new HenGioTB(
                        object.getInt("id"),
                        object.getString("ten"),
                        object.getString("gioON"),
                        object.getString("phutON"),
                        object.getString("gioOFF"),
                        object.getString("phutOFF"))
                );
            }
            ganData();
        } catch (JSONException e) {
            e.printStackTrace();
        }
       // Toast.makeText(getActivity(), data.toString(), Toast.LENGTH_SHORT).show();
    }

    void capnhapDataHenGioOn(JSONObject data)
    {
        try {
            henGioTBArrayList2.get(data.getInt("id")).setGioOn(data.getString("gioON"));
            henGioTBArrayList2.get(data.getInt("id")).setPhutOn(data.getString("phutON"));
            henGioTBAdapter.notifyDataSetChanged();
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    void capnhapDataHenGioOff(JSONObject data)
    {
        try {
            henGioTBArrayList2.get(data.getInt("id")).setGioOff(data.getString("gioOFF"));
            henGioTBArrayList2.get(data.getInt("id")).setPhutOff(data.getString("phutOFF"));
            henGioTBAdapter.notifyDataSetChanged();
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    void capnhapDeleteHenGioTB(JSONObject data)
    {
        try {
            henGioTBArrayList2.get(data.getInt("id")).setGioOn("70");
            henGioTBArrayList2.get(data.getInt("id")).setPhutOn("70");
            henGioTBArrayList2.get(data.getInt("id")).setGioOff("70");
            henGioTBArrayList2.get(data.getInt("id")).setPhutOff("70");
            henGioTBAdapter.notifyDataSetChanged();
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }
}
