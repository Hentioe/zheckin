import React from "react";
import { useDispatch } from "react-redux";
import { useParams } from "react-router-dom";
import useSWR from "swr";
import unfetch from "unfetch";
import moment from "moment";

import { setMenuTitle } from "../actions";

const HistoryCard = ({ date, msg }) => {
  return (
    <div className="flex justify-between items-center rounded-lg shadow p-4 mb-4">
      <div className="flex items-center">
        <span className="text-xl">{date}</span>
      </div>
      <span className="text-xl">{msg}</span>
    </div>
  );
};

export default () => {
  const dispatch = useDispatch();
  const { id } = useParams();

  const { data, error } = useSWR(
    `/console/api/histories/clubs/${id}?limit=30`,
    url => unfetch(url).then(r => r.json())
  );

  if (error) return <div>加载出错</div>;
  if (!data) return <div>加载中……</div>;

  const { club, histories } = data.data;

  dispatch(setMenuTitle(club.name));

  return (
    <div className="p-4">
      {histories.map(h => (
        <HistoryCard
          key={h.id}
          date={moment(h.updated_at).format("YYYY-MM-DD HH:mm")}
          msg={h.msg}
        />
      ))}
    </div>
  );
};
