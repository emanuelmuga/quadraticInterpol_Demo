function fi2file(vector_fi, file_name)
    rows = numel(vector_fi);

        fid = fopen(file_name, 'w+');
        for j = 1:rows
            Strg = hex(vector_fi(j));
            fprintf(fid,'%s\n', Strg);
        end
        fclose(fid);
end