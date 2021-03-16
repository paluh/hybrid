module Hybrid.App.Client.Render where

-- import Prelude
-- 
-- import Control.Monad.Except (ExceptT(..), runExceptT, throwError)
-- import Data.Tuple.Nested ((/\), type (/\))
-- import Data.Either (Either)
-- import Data.Maybe (Maybe(..))
-- import Data.Traversable (for)
-- import Data.Variant (Variant)
-- import Heterogeneous.Folding (class FoldingWithIndex, class HFoldlWithIndex, hfoldlWithIndex)
-- import Hybrid.Api.Spec (ResponseCodec(..))
-- import Hybrid.App.Renderer (Renderer)
-- import Hybrid.App.Spec (Raw(..)) as Spec
-- import Hybrid.HTTP.Exchange (Exchange(..)) as HTTP
-- import Hybrid.HTTP.Exchange (FetchError(..))
-- import Hybrid.HTTP.Response (Response)
-- import Prim.Row (class Cons) as Row
-- import Record (get) as Record
-- import Type.Prelude (class IsSymbol, SProxy)
-- 
-- -- | We should put here `Spec` directly and not its piceses
-- data RenderFolding router req res rnd
--   = RenderFolding
--     router
--     (Spec.Raw req res rnd)
-- 
-- instance renderFolding ::
--   ( IsSymbol sym
--   , Row.Cons sym (ResponseCodec res) response_ response
--   , Row.Cons sym (Renderer router req res doc) render_ render
--   , Row.Cons sym req request_ request
--   ) =>
--   FoldingWithIndex
--     (RenderFolding router request response render)
--     (SProxy sym)
--     Unit
--     req
--     (Maybe (Either FetchError (Response String)) → doc) where
--   foldingWithIndex (RenderFolding router (Spec.Raw spec)) prop _ req res =
--     let
--       renderer = Record.get prop spec.renderers
-- 
--       ResponseCodec respCodec = Record.get prop spec.codecs.response
-- 
--       exch' =
--         HTTP.Exchange req
--           $ runExceptT do
--               rawRes ← ExceptT res
--               for rawRes \content → case respCodec.decode content of
--                 Just resp → pure resp
--                 Nothing → throwError (FetchError $ "Response decoding error: " <> content)
--     in
--       renderer (router /\ exch')
-- 
-- render ::
--   ∀ doc rnd res req router.
--   HFoldlWithIndex (RenderFolding router req res rnd) Unit (Variant req) (Maybe (Either FetchError (Response String)) → doc) ⇒
--   Spec.Raw req res rnd →
--   (router /\ HTTP.Exchange (Variant req) String) →
--   doc
-- render spec@(Spec.Raw { codecs }) (router /\ HTTP.Exchange req res) = do
--   hfoldlWithIndex (RenderFolding router spec) unit req res
