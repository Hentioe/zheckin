import React, { useEffect, useState, useRef } from "react";
import styled from "styled-components";
import clsx from "clsx";
import { useDispatch } from "react-redux";
import fetch from "unfetch";

import { hiddenHeader, hiddenFooter } from "../slices/root";
import { Logo } from "../components/Header";

import fromChromePNG from "../../res/from_chrome.png";
import fromFirefoxPNG from "../../res/from_firefox.png";

const LoginSection = styled.section.attrs(() => ({
  className: clsx(
    ["min-h-screen", "w-full", "bg-white"],
    ["flex", "flex-wrap", "items-center"]
  )
}))``;

const Input = ({ value, lable, type, name, onChange, isHidden }) => {
  return (
    <>
      <label
        style={{ display: isHidden ? "none" : "initial" }}
        className="text-sm text-gray-600 font-semibold"
      >
        {lable}
      </label>
      <input
        style={{ display: isHidden ? "none" : "initial" }}
        value={value}
        type={type}
        name={name}
        onChange={onChange}
        className="mt-1 mb-5 focus:outline-none focus:shadow-outline border border-gray-300 rounded py-1 px-2 block w-full appearance-none leading-normal"
      />
    </>
  );
};

const Tabs = ({ items }) => {
  const [selectIndex, setSelectIndex] = useState(0);

  const handleChangeSelect = (e, i) => {
    e.preventDefault();
    if (i === selectIndex) return;
    setSelectIndex(i);
  };

  return (
    <div className="bg-white rounded shadow pb-4">
      <ul className="flex mb-8">
        {items.map(({ name }, i) =>
          i === selectIndex ? (
            <li key={i} className="flex-1">
              <a
                className="text-center block border border-blue-500 rounded py-2 px-4 bg-blue-500 hover:bg-blue-700 text-white"
                href="#"
                onClick={e => handleChangeSelect(e, i)}
              >
                {name}
              </a>
            </li>
          ) : (
            <li key={i} className="flex-1">
              <a
                className="text-center block border border-white rounded hover:border-gray-100 text-blue-500 bg-white hover:bg-gray-100 py-2 px-4"
                href="#"
                onClick={e => handleChangeSelect(e, i)}
              >
                {name}
              </a>
            </li>
          )
        )}
      </ul>
      <div>{items[selectIndex].content}</div>
    </div>
  );
};

const Card = styled.div.attrs(() => ({
  className: clsx("bg-white rounded shadow")
}))``;

const CardHeader = styled.header.attrs(() => ({
  className: clsx("border-b border-gray-400 p-4 text-xl")
}))``;

const CardContent = styled.header.attrs(() => ({
  className: clsx("p-6 text-gray-600 text-sm md:text-base")
}))``;

export default () => {
  const dispatch = useDispatch();

  useEffect(() => {
    dispatch(hiddenHeader());
    dispatch(hiddenFooter());
  }, []);

  const [formData, setFormData] = useState({
    api_token: "",
    email: ""
  });

  const handleFetchAccount = e => {
    e.preventDefault();

    fetch("/sign_in", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify(formDataRef.current)
    })
      .then(r => r.json())
      .then(handleLoginResult);
  };

  const [loginResult, setLoginResult] = useState({ ok: null, msg: null });
  const [isEmailHidden, setIsEmailHidden] = useState(true);
  const [enterBtn, setEnterBtn] = useState({
    text: "登入",
    onClick: handleFetchAccount
  });

  useEffect(() => {
    formDataRef.current = formData;
  }, [formData]);

  const handleEmailChange = e => {
    setFormData(Object.assign({}, formData, { email: e.target.value }));
  };

  const handleApiTokenChange = e => {
    setFormData(Object.assign({}, formData, { api_token: e.target.value }));
  };

  const formDataRef = useRef(formData);

  const handleLoginResult = json => {
    if (json.error) {
      setLoginResult(
        Object.assign({}, loginResult, { ok: false, msg: data.error.msg })
      );
    } else {
      const { account, email_setted, clubs } = json.data;
      if (email_setted === false) {
        // 如果没有设置过邮箱，需二次确认
        setLoginResult(
          Object.assign({}, loginResult, {
            ok: true,
            msg: `登入成功，请补全邮箱。`
          })
        );
        const { email } = account;
        setIsEmailHidden(false);
        setFormData(Object.assign({}, formDataRef.current, { email: email }));
        setEnterBtn(Object.assign({}, enterBtn, { text: "确认" }));
      } else if (!clubs) {
        // 获取圈子列表
        setLoginResult(
          Object.assign({}, loginResult, {
            ok: true,
            msg: `正在获取圈子列表……`
          })
        );
        fetch("/console/api/accounts/refresh_joined_clubs", {
          method: "PUT",
          headers: {
            "Content-Type": "application/json"
          }
        })
          .then(r => r.json())
          .then(handleLoginResult);
      } else {
        setLoginResult(
          Object.assign({}, loginResult, {
            ok: true,
            msg: `准备跳转到控制台……`
          })
        );
        setTimeout(() => {
          location.href = "/console";
        }, 500);
      }
    }
  };

  return (
    <div>
      <LoginSection>
        <div className="p-6 lg:px-32 w-full md:w-5/12">
          <Logo routable />
          <h1 className="mt-10 text-2xl lg:text-3xl font-semibold text-gray-700">
            登录云签到
          </h1>
          <p className="pt-4 text-gray-500">请先按照教程获取令牌</p>
          <form className="mt-6" method="POST">
            <Input
              lable="令牌"
              type="password"
              name="api_token"
              value={formData.api_token}
              onChange={handleApiTokenChange}
            />
            <Input
              isHidden={isEmailHidden}
              lable="邮箱"
              type="text"
              name="email"
              value={formData.email}
              onChange={handleEmailChange}
            />
            <div className="mt-5">
              <button
                className="px-8 py-2 rounded shadow text-sm font-semibold text-white bg-blue-500"
                onClick={enterBtn.onClick}
              >
                {enterBtn.text}
              </button>
              {loginResult.msg ? (
                <span
                  className="ml-2 text-sm"
                  style={{ color: loginResult.ok ? "green" : "red" }}
                >
                  {loginResult.msg}
                </span>
              ) : null}
            </div>
          </form>
          <div className="mt-10">
            <p className="text-center">
              <span className="text-gray-600">不懂怎么做？</span>
              <a
                className="text-blue-500"
                href="https://www.zhihu.com/people/Hentioe"
                target="_blank"
              >
                联系作者
              </a>
            </p>
          </div>
          <div className="mt-16">
            <p className="text-center text-xs font-mono text-gray-600">
              Copyright © 2019 ZHECKIN
            </p>
          </div>
        </div>
        <div className="w-full md:w-7/12 px-4 pb-4">
          <Card className="mt-2">
            <CardHeader>
              <p>关于认证令牌</p>
            </CardHeader>
            <CardContent>
              <p>
                认证令牌是您访问知乎时“证明”自己身份的一个 Token 字符串，它基于
                JWT，不包含隐私信息。知乎将它存储在 Cookie 中，名为 "z_c0"。
              </p>
            </CardContent>
          </Card>
          <Card className="mt-2">
            <CardHeader>
              <p>获取方法</p>
            </CardHeader>
            <CardContent>
              <p className="mb-12">
                首先进入并登录知乎，处于任意页面都可。按 F12 键，查看 Cookie
                的并获取 z_c0。不同浏览器查看 Cookie
                的方式不同，以下列举了最常见的两种浏览器的获取方法，请按照截图操作。
              </p>
              <Tabs
                items={[
                  { name: "Chrome", content: <img src={fromChromePNG} /> },
                  { name: "Firefox", content: <img src={fromFirefoxPNG} /> }
                ]}
              />
            </CardContent>
          </Card>
          <Card className="my-2">
            <CardHeader>
              <p>额外数据</p>
            </CardHeader>
            <CardContent>
              <p>
                在初次登录或始终没有设置邮箱的前提下，会进一步要求补全邮箱。默认填充的邮箱是您绑定知乎时的半隐藏邮箱地址，本程序无法获取您的完整邮箱，因此需要您手动补全。注意，本程序要求用户填写邮箱纯粹是为了安全考虑，发生意外情况时可以第一时间通知到您。你可以不设置（保持半隐藏），它并非强制，但不要设置错误的地址。
              </p>
            </CardContent>
          </Card>
        </div>
      </LoginSection>
    </div>
  );
};
