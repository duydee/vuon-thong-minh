package com.example.appvuonthongminh;

import android.app.ListFragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;

import androidx.annotation.NonNull;

import java.util.ArrayList;

public class ListFlagmentHenGioCot1 extends ListFragment {
    ArrayList<ThietBi> thietBiArrayList;
    ThietBiAdapter thietBiAdapter;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        thietBiArrayList = new ArrayList<>();
        AddHengioTB();

        thietBiAdapter = new ThietBiAdapter(getActivity(),R.layout.dong_cot1, thietBiArrayList);
        setListAdapter(thietBiAdapter);

        return inflater.inflate(R.layout.listflagment,container,false);
    }

    private void AddHengioTB()
    {
        thietBiArrayList.add(new ThietBi(0,"Đèn khu 1"));
        thietBiArrayList.add(new ThietBi(1,"Đèn khu 2"));
        thietBiArrayList.add(new ThietBi(2,"Đèn khu 3"));
        thietBiArrayList.add(new ThietBi(3,"Quạt khu 1"));
        thietBiArrayList.add(new ThietBi(4,"Quạt khu 2"));
        thietBiArrayList.add(new ThietBi(5,"Quạt khu 3"));
        thietBiArrayList.add(new ThietBi(6,"Bơm khu 1"));
        thietBiArrayList.add(new ThietBi(7,"Bơm khu 2"));
        thietBiArrayList.add(new ThietBi(8,"Bơm khu 3"));
    }

    @Override
    public void onListItemClick(@NonNull ListView l, @NonNull View v, int position, long id) {
        ListFlagmentHenGioCot2 listFlagmentHenGioCot2 = (ListFlagmentHenGioCot2) getFragmentManager().findFragmentById(R.id.layoutCot2);
        listFlagmentHenGioCot2.flagHengio(thietBiArrayList.get(position).getId());

        super.onListItemClick(l, v, position, id);
    }
}
