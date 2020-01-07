import React from "react";
import { Link, useLocation } from "react-router-dom";
import { useSelector } from "react-redux";
import styled from "styled-components";
import clsx from "clsx";

import todayPNG from "../../res/today.png";

const _Item = styled(Link).attrs(({ selected }) => ({
  className: clsx(
    ["px-4", "py-2", "m-2"], // 间距
    ["flex", "items-center", "flex-no-wrap"], // 布局
    ["rounded-full", "hover:bg-blue-200"], // 圆角/前景色
    [{ "bg-blue-200": selected }]
  )
}))``;

const Item = ({ to, iconUrl, text, selected }) => {
  return (
    <_Item selected={selected} to={to}>
      <img
        className="flex-initial h-10 w-10 rounded-full inline"
        src={iconUrl}
      />
      {text && (
        <span
          className="hidden md:inline ml-4 text-xl font-medium"
          style={{
            overflow: "hidden",
            textOverflow: "ellipsis",
            whiteSpace: "nowrap"
          }}
        >
          {text}
        </span>
      )}
    </_Item>
  );
};

export default ({ className }) => {
  const location = useLocation();
  const { clubs } = useSelector(state => state.root);

  return (
    <header className={className}>
      <Item
        iconUrl={CURRENT_USER.avatar.replace("{size}", "im")}
        text="个人设置"
        to="/console/settings"
        selected={`/console/settings` === location.pathname}
      />
      <Item
        iconUrl={todayPNG}
        text="今日签到"
        to="/console/today"
        selected={"/console/today" === location.pathname}
      />
      <hr />
      {clubs.map(club => (
        <Item
          key={club.id}
          to={`/console/histories/clubs/${club.id}`}
          selected={`/console/histories/clubs/${club.id}` === location.pathname}
          iconUrl={club.avatar.replace("pic3.zhimg.com", "pic1.zhimg.com")}
          text={club.name}
        />
      ))}
    </header>
  );
};
