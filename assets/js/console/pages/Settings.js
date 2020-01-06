import React, { useState } from "react";
import styled from "styled-components";
import clsx from "clsx";

const _PropertyBox = styled.div.attrs(({ clickable, dangerous }) => ({
  className: clsx(
    ["flex justify-between border-t p-2 pl-4"],
    [
      { "cursor-pointer": clickable },
      { "hover:bg-gray-200": clickable && !dangerous }
    ],
    [{ "hover:bg-red-200": dangerous, "text-red-600": dangerous }]
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
export default () => {
  const [checkinEnabled, setCheckinEnabled] = useState(false);

  const handleCheckinEnabled = _ => {
    setCheckinEnabled(!checkinEnabled);
  };

  const handleRevokeToken = _ => {
    console.log("revoking...");
  };

  const handleRefreshClubs = _ => {
    console.log("refreshing...");
  };

  return (
    <div>
      <Properties title="个人资料">
        <TextProperty title="用户名" text={url_token} />
        <TextProperty title="姓名" text={name} />
        <TextProperty title="邮箱" text={email} />
        <TextProperty title="已加入圈子" text={`6 个`} />
      </Properties>
      <Properties className="mt-2" title="签到设置">
        <SwitchProperty
          title="停止签到"
          text="暂停自动签到服务"
          onChange={handleCheckinEnabled}
          checked={checkinEnabled}
        />
      </Properties>
      <Properties className="mt-2" title="帐号设置">
        <PropertyBox
          clickable
          title="刷新圈子"
          text="立即同步已经加入的圈子列表"
          onClick={handleRefreshClubs}
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
