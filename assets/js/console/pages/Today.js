import React, { useEffect } from "react";
import styled from "styled-components";
import clsx from "clsx";
import { useDispatch } from "react-redux";
import useSWR from "swr";
import unfetch from "unfetch";

import { setMenuTitle } from "../actions";

const _Today = styled.div.attrs(() => ({
  className: clsx(["p-4"])
}))``;

const HistoryCard = ({ avatar, name, background, ok }) => {
  return (
    <div
      style={{ backgroundImage: `url(${background})` }}
      className="flex justify-between items-center rounded-lg shadow p-4 mb-4 bg-no-repeat bg-cover"
    >
      <div className="flex items-center">
        <img className="w-16 h-16 rounded-lg shadow" src={avatar} />
        <span
          className="text-white font-bold ml-2 p-2 rounded"
          style={{ backgroundColor: "rgba(0, 0, 0, 0.3)" }}
        >
          {name}
        </span>
      </div>
      <span
        className="p-2 rounded-lg"
        style={{ backgroundColor: "rgba(0, 0, 0, 0.5)" }}
      >
        {ok ? "✅" : "❎"}
      </span>
    </div>
  );
};

export default () => {
  const dispatch = useDispatch();

  useEffect(() => {
    dispatch(setMenuTitle("今日签到"));
  }, []);

  const { data, error } = useSWR("/console/api/histories/today", url =>
    unfetch(url).then(r => r.json())
  );

  if (error) return <div>加载出错</div>;
  if (!data) return <div>加载中……</div>;

  const { histories } = data.data;

  return (
    <_Today>
      {histories.map(({ id, msg, club }) => (
        <HistoryCard
          key={id}
          avatar={club.avatar.replace("pic3.zhimg.com", "pic1.zhimg.com")}
          name={club.name}
          background={club.background.replace(
            "pic3.zhimg.com",
            "pic1.zhimg.com"
          )}
          ok={["OK", "已签到"].includes(msg)}
        />
      ))}
    </_Today>
  );
};
