function [ reduced ] = reduceLevels( Img, maxLvl )
    reduced = round(double(Img)/double(max(Img(:))) * double(maxLvl));
end

