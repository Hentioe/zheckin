import React, { useState, useEffect } from "react";
import styled from "styled-components";
import clsx from "clsx";
import { useDispatch, useSelector } from "react-redux";
import unfetch from "unfetch";

import { setMenuTitle, syncClubs } from "../actions";

const _PropertyBox = styled.div.attrs(({ clickable, dangerous }) => ({
  className: clsx(
    ["flex", "justify-between"], // 布局
    ["border-t", "p-2", "pl-4"], // 边框/间距
    [
      {
        "cursor-pointer": clickable,
        "hover:bg-gray-200": clickable && !dangerous,
        "hover:bg-red-200": dangerous,
        "text-red-600": dangerous
      }, // 前/背景色
      {
        "select-none": clickable
      } // 是否可选
    ]
  )
}))``;

const Properties = ({ className = "", title, children }) => {
  return (
    <div className={["bg-white", className].join(" ")}>
      <h1 className="text-lg font-bold p-3 pl-4">{title}</h1>
      {children}
    </div>
  );
};

const PropertyBox = ({
  title,
  text,
  children,
  clickable = false,
  dangerous = false,
  onClick = _ => {}
}) => {
  return (
    <_PropertyBox clickable={clickable} dangerous={dangerous} onClick={onClick}>
      <div>
        <h2 className="text-base">{title}</h2>
        <span className="text-sm text-gray-600">{text}</span>
      </div>
      {children}
    </_PropertyBox>
  );
};

const TextProperty = ({ title, text }) => (
  <PropertyBox title={title} text={text} />
);

const SwitchProperty = ({ title, text, checked, onChange = _ => {} }) => {
  return (
    <PropertyBox clickable title={title} text={text} onClick={onChange}>
      <input
        className="cursor-pointer"
        type="checkbox"
        onChange={onChange}
        checked={checked}
      />
    </PropertyBox>
  );
};

const { url_token, name, email } = CURRENT_USER;

const INITIAL = {
  SYNC_CLUBS_MSG: "立即同步已经加入的圈子列表",
  CHECKIN_DISABLE_MSG_HINT: "暂停自动签到服务",
  CHECKIN_DISABLING_MSG: "正在禁用签到……",
  CHECKIN_ENABLING_MSG: "正在启用签到……"
};

export default () => {
  const dispatch = useDispatch();
  const { clubs } = useSelector(state => state.root);

  useEffect(() => {
    dispatch(setMenuTitle("设置页面"));
  }, []);

  const [checkinDisabled, setCheckinDisabled] = useState(!CURRENT_USER.enabled);
  const [checkinDisableProperty, setCheckinDisableProperty] = useState({
    loading: false,
    msg: INITIAL.CHECKIN_DISABLE_MSG_HINT
  });

  const handleCheckinDisabled = _ => {
    setCheckinDisableProperty(
      Object.assign({}, checkinDisableProperty, {
        loading: true,
        msg: checkinDisabled
          ? INITIAL.CHECKIN_ENABLING_MSG
          : INITIAL.CHECKIN_DISABLING_MSG
      })
    );
    unfetch("/console/api/accounts/disabled", { method: "PUT" })
      .then(r => r.json())
      .then(json => {
        setCheckinDisableProperty(
          Object.assign({}, checkinDisableProperty, {
            loading: false,
            msg: INITIAL.CHECKIN_DISABLE_MSG_HINT
          })
        );
        setCheckinDisabled(!json.data.account.enabled);
      });
  };

  const handleRevokeToken = _ => {
    console.log("revoking...");
  };

  const [syncClubsProperty, setSyncClubsProperty] = useState({
    loading: false,
    msg: INITIAL.SYNC_CLUBS_MSG
  });

  const handleRefreshClubs = _ => {
    setSyncClubsProperty(
      Object.assign({}, syncClubsProperty, {
        loading: true,
        msg: "正在同步圈子列表……"
      })
    );
    dispatch(syncClubs());
  };

  useEffect(() => {
    if (syncClubsProperty.loading) {
      setSyncClubsProperty(
        Object.assign({}, syncClubsProperty, {
          loading: false,
          msg: "同步完成"
        })
      );
    }
  }, [clubs]);

  return (
    <div className="bg-gray-200">
      <Properties title="个人资料">
        <TextProperty title="用户名" text={url_token} />
        <TextProperty title="姓名" text={name} />
        <TextProperty title="邮箱" text={email} />
        <TextProperty title="已加入圈子" text={`${clubs.length} 个`} />
      </Properties>
      <Properties className="mt-2" title="签到设置">
        <SwitchProperty
          title="停止签到"
          text={checkinDisableProperty.msg}
          onChange={handleCheckinDisabled}
          checked={checkinDisabled}
        />
      </Properties>
      <Properties className="mt-2" title="帐号设置">
        <PropertyBox
          clickable
          title="刷新圈子"
          text={syncClubsProperty.msg}
          onClick={handleRefreshClubs}
        />
        <PropertyBox
          clickable
          title="注销登录"
          text="注销本站登录状态，不影响认证令牌有效性"
          onClick={() => {
            location.href = "/logout";
          }}
        />
        <PropertyBox
          dangerous
          clickable
          title="吊销令牌"
          text="让令牌失效，可能影响其它端的登录状态"
          onClick={handleRevokeToken}
        />
      </Properties>
    </div>
  );
};
