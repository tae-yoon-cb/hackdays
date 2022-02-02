import { BuyPackButton } from "../BuyPackButton";
import { useGetAllCollections } from "../../hooks/useGetAllCollections";

export const Page = () => {
  const collections = useGetAllCollections();

  return (
    <div>
      {collections?.state?.length > 0 &&
        collections.state.map((collection) => {
          return <div>{collection.name}</div>;
        })}
      <BuyPackButton />
    </div>
  );
};
