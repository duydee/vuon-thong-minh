package com.example.appvuonthongminh;

import android.app.ListFragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;

import androidx.annotation.NonNull;

import java.util.ArrayList;

public class ListFlagmentControlCot1 extends ListFragment {
    ArrayList<ThietBi> thietBiArrayList;
    ThietBiAdapter thietBiAdapter;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        thietBiArrayList = new ArrayList<>();
        AddControlTB();

        thietBiAdapter = new ThietBiAdapter(getActivity(),R.layout.dong_cot1, thietBiArrayList);
        setListAdapter(thietBiAdapter);

        return inflater.inflate(R.layout.listflagment,container,false);
    }

    private void AddControlTB()
    {
        thietBiArrayList.add(new ThietBi(0,"SenSer"));
        thietBiArrayList.add(new ThietBi(1,"Đèn"));
        thietBiArrayList.add(new ThietBi(2,"Quạt"));
        thietBiArrayList.add(new ThietBi(3,"Bơm"));
        thietBiArrayList.add(new ThietBi(4,"Relay"));
    }

    @Override
    public void onListItemClick(@NonNull ListView l, @NonNull View v, int position, long id) {
        ListFlagmentControlCot2 listFlagmentControlCot2 = (ListFlagmentControlCot2) getFragmentManager().findFragmentById(R.id.layoutCot2);
        listFlagmentControlCot2.flagControl(thietBiArrayList.get(position).getId());

        super.onListItemClick(l, v, position, id);
    }
}
