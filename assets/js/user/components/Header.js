import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import styled from "styled-components";
import clsx from "clsx";
import { TOP_HEIGHT } from "./MainContainer";

const Nav = styled.nav.attrs(({ scrolled, headerHidden }) => ({
  className: clsx(
    ["w-full", "fixed", "top-0", "z-50"], // 宽度/位置
    ["flex", "flex-wrap", "items-center", "justify-between"], // 布局
    ["p-6", "lg:px-32"], // 间距
    ["bg-white"],
    [{ shadow: scrolled }], // 阴影
    [{ hidden: headerHidden }]
  )
}))`
  min-height: ${TOP_HEIGHT};
`;

const Logo = ({ routable }) => {
  const className = "font-normal text-2xl";
  const Text = (
    <>
      <span className="tracking-tight text-blue-500">Z</span>
      <span>heck</span>
      <span className="tracking-tight text-blue-500">In</span>
    </>
  );
  if (routable)
    return (
      <Link to="/" className={className}>
        {Text}
      </Link>
    );
  else
    return (
      <a href="/" className={className}>
        {Text}
      </a>
    );
};

const MenuClassName = clsx(
  ["text-gray-800", "hover:bg-gray-100"],
  ["p-4"],
  ["rounded-full"]
);

const RouteMenu = styled(Link).attrs(() => ({
  className: MenuClassName
}))``;

const LinkMenu = styled.a.attrs(() => ({
  className: MenuClassName
}))``;

export default ({ headerHidden }) => {
  // 滚动状态
  const [scrolled, setScrolled] = useState(false);
  // 添加滚动事件，动态变化背景色和阴影
  useEffect(() => {
    window.addEventListener("scroll", e => {
      const y = window.scrollY;
      setScrolled(y > 0);
    });
  }, []);

  return (
    <header>
      <Nav scrolled={scrolled} headerHidden={headerHidden}>
        {/* LOGO */}
        <Logo />
        {/* Menu */}
        <div>
          {CURRENT_USER ? (
            <LinkMenu href="/console">控制台</LinkMenu>
          ) : (
            <RouteMenu to="/login">登录</RouteMenu>
          )}
        </div>
      </Nav>
    </header>
  );
};

export { Logo };
