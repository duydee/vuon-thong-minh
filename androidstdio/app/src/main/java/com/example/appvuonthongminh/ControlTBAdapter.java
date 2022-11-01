package com.example.appvuonthongminh;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.Locale;

public class ControlTBAdapter extends BaseAdapter {
    MainActivity context;
    int layout;
    ArrayList<ControlTB> controlTBS;

    public ControlTBAdapter(MainActivity context, int layout, ArrayList<ControlTB> controlTBS) {
        this.context = context;
        this.layout = layout;
        this.controlTBS = controlTBS;
    }

    @Override
    public int getCount() {
        return controlTBS.size();
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
        TextView tenTB,trangthaiTB;
        Button btnOnTB,btnOffTB;
    }
    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        viewholder holder;
        if(convertView == null)
        {
            holder = new viewholder();
            LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = inflater.inflate(layout,null);
            holder.tenTB = (TextView) convertView.findViewById(R.id.textViewTenStatusTb);
            holder.trangthaiTB = (TextView) convertView.findViewById(R.id.textViewTrangthaiStatusTb);
            holder.btnOnTB = (Button) convertView.findViewById(R.id.buttonONStatusTb);
            holder.btnOffTB = (Button) convertView.findViewById(R.id.buttonOFFStatusTb);

            convertView.setTag(holder);
        }
        else
        {
            holder = (viewholder) convertView.getTag();
        }

        ControlTB tb = controlTBS.get(position);
        holder.tenTB.setText(capitalizeString(tb.getTenTB()));

        if(tb.trangthai.equals("1"))
        {
            holder.trangthaiTB.setText("ON");
        }
        else
        {
            holder.trangthaiTB.setText("OFF");
        }

        holder.btnOnTB.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
              //  Toast.makeText(context, "ON", Toast.LENGTH_SHORT).show();
                if(tb.trangthai.equals("0"))
                {
                    tb.trangthai = "1";
                    context.updatedataStatusTB(tb);
                }
                else
                {
                    Toast.makeText(context, "Thiết bị đã bật", Toast.LENGTH_SHORT).show();
                }
            }
        });

        holder.btnOffTB.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            //    Toast.makeText(context, "OFF", Toast.LENGTH_SHORT).show();
                if(tb.trangthai.equals("1"))
                {
                    tb.trangthai = "0";
                    context.updatedataStatusTB(tb);
                }
                else
                {
                    Toast.makeText(context, "Thiết bị đã tắt", Toast.LENGTH_SHORT).show();
                }
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
