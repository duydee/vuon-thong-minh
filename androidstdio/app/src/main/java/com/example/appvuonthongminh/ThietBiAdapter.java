package com.example.appvuonthongminh;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import java.util.ArrayList;

public class ThietBiAdapter extends BaseAdapter {

    Context context;
    int layout;
    ArrayList<ThietBi> thietBis;

    public ThietBiAdapter(Context context, int layout, ArrayList<ThietBi> thietBis) {
        this.context = context;
        this.layout = layout;
        this.thietBis = thietBis;
    }

    @Override
    public int getCount() {
        return thietBis.size();
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
    }
    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        viewholder holder;
        if(convertView == null)
        {
            holder = new viewholder();
            LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = inflater.inflate(layout,null);
            holder.tenTB = convertView.findViewById(R.id.textViewTenTb);
            convertView.setTag(holder);
        }
        else
        {
            holder = (viewholder) convertView.getTag();
        }
        ThietBi tb = thietBis.get(position);
        holder.tenTB.setText(tb.getTen().toUpperCase());

        return convertView;
    }
}
