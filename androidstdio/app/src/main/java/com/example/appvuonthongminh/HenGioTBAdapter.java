package com.example.appvuonthongminh;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.TextView;

import java.util.ArrayList;

public class HenGioTBAdapter extends BaseAdapter {
    MainActivity context;
    int layout;
    ArrayList<HenGioTB> henGioTBS;

    public HenGioTBAdapter(MainActivity context, int layout, ArrayList<HenGioTB> henGioTBS) {
        this.context = context;
        this.layout = layout;
        this.henGioTBS = henGioTBS;
    }

    @Override
    public int getCount() {
        return henGioTBS.size();
    }

    @Override
    public Object getItem(int position) {
        return null;
    }

    @Override
    public long getItemId(int position) {
        return 0;
    }

    private class viewholder
    {
        TextView tenTB;
        TextView txtGioOn,txtPhutOn,txtGioOff,txtPhutOff;
        Button btnSuaHenGioOn,btnSuaHenGioOff,btnXoaHenGio;
    }
    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        viewholder holder;
        if(convertView == null)
        {
            holder = new viewholder();
            LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = inflater.inflate(layout,null);
            holder.tenTB = (TextView) convertView.findViewById(R.id.textViewtenHengioTb);
            holder.txtGioOn = (TextView) convertView.findViewById(R.id.textViewGioOnHengioTB);
            holder.txtPhutOn = (TextView) convertView.findViewById(R.id.textViewPhutOnHengioTB);
            holder.txtGioOff = (TextView) convertView.findViewById(R.id.textViewGioOffHengioTB);
            holder.txtPhutOff = (TextView) convertView.findViewById(R.id.textViewPhutOffHengioTB);
            holder.btnSuaHenGioOn = (Button) convertView.findViewById(R.id.buttonSuaHengioONTB);
            holder.btnSuaHenGioOff = (Button) convertView.findViewById(R.id.buttonSuaHengioOFFTB);
            holder.btnXoaHenGio = (Button) convertView.findViewById(R.id.buttonXoaHengioTB);
            convertView.setTag(holder);
        }
        else
        {
            holder = (viewholder) convertView.getTag();
        }

        HenGioTB tb = henGioTBS.get(position);

        holder.tenTB.setText(capitalizeString(tb.getTenTB()));

        holder.txtGioOn.setText(tb.GioOn);
        holder.txtPhutOn.setText(tb.PhutOn);
        holder.txtGioOff.setText(tb.GioOff);
        holder.txtPhutOff.setText(tb.phutOff);

        holder.btnSuaHenGioOn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                context.DialogSuaHengioOn(tb);
            }
        });

        holder.btnSuaHenGioOff.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                context.DialogSuaHengioOff(tb);
            }
        });

        holder.btnXoaHenGio.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                context.DialogXoaThietBi(tb.id,tb.tenTB);
            }
        });


        return convertView;
    }
    public static String capitalizeString(String str) {
        String retStr = str;
        try { // We can face index out of bound exception if the string is null
            retStr = str.substring(0, 1).toUpperCase() + str.substring(1);
        }catch (Exception e){}
        return retStr;
    }

}
