import { useCallback } from "react";
import styled from "styled-components";

import { useBuyPack } from "../../hooks/useBuyPack";

export const BuyPackButton = () => {
  const { send } = useBuyPack();

  const onClick = useCallback(() => {
    send("hello world");
  }, [send]);

  return <BuyButton onClick={onClick}>Buy pack</BuyButton>;
};

const BuyButton = styled.button`
  width: 100%;
  margin-top: 60px;
  padding: 12px 16px;
  font-size: 18px;
  background: #ff5733;
  color: #ffffff;
  font-weight: bold;
  cursor: pointer;
  border: 0;
  border-radius: 4px;
`;
